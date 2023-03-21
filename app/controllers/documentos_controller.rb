require 'nokogiri'
require 'builder'
require 'pdf-reader'


# require 'barby/barcode/itf'
# require 'barby/outputter/svg_outputter'

class DocumentosController < ApplicationController
  before_action :set_documento, only: %i[ show edit update destroy ]

  # GET /documentos or /documentos.json
  def index
    @documentos = Documento.all
  end

  # GET /documentos/1 or /documentos/1.json
  def show
    
  end

  def download_pdf
    @documento = Documento.find(params[:id])
    send_data @documento.archivo_pdf.download, filename: @documento.archivo_pdf.filename.to_s, type: 'application/pdf', disposition: 'attachment'
    #send_data @documento.archivo_pdf.download, filename: @documento.archivo_pdf.filename.to_s, type:  'application/pdf'
    
  end




  # GET /documentos/new
  def new
    @documento = Documento.new
  end

  # GET /documentos/1/edit
  def edit
  end

  # POST /documentos or /documentos.json

  def create
    respond_to do |format|

      @documento = Documento.new(documento_params)
      @documento.user = current_user
      #@documento = current_user.documentos.new(documento_params)
      #@documento.user = current_user
      if @documento.save

       # @document.pdf_path = pdf_path.to_s
        # Obtenemos el objeto ActiveStorage::Blob asociado al archivo subido
        blob = @documento.uploads.first.blob
        md5 = blob.checksum
        updated_at = File.mtime(blob.service.path_for(blob.key)).strftime('%Y-%m-%d %H:%M:%S %z')
        created_at = File.mtime(blob.service.path_for(blob.key)).strftime('%Y-%m-%d %H:%M:%S')
        # Se asume que el archivo subido se ha adjuntado a un objeto ActiveStorage::Blob y se ha recuperado en la variable 'blob'
        

        # Leer el contenido del archivo PDF
        pdf_content = blob.download
        
        # Crear un objeto PDF::Reader
        pdf_reader = PDF::Reader.new(StringIO.new(pdf_content))

        #send_data @documento.archivo_pdf.download, filename: @documento.archivo_pdf.filename.to_s, type:  'application/pdf'

  

        # Expresión regular para encontrar códigos de 16 dígitos
        

        serial_regex = /\d{16}/ 
        serial = ""
        pdf_reader.pages.each do |page|
          page_content = page.text
        
          # Buscar el código de barras en el contenido de la página
          serial_match = page_content.match(serial_regex)
          if serial_match
            serial = serial_match[0]
            break # Si se encuentra el código de barras, salir del bucle
          end
        end
                
        #pdf_path = blob.service.path_for(blob.key)
        # Obtener el contenido de cada página del PDF
        page_contents = pdf_reader.pages.map { |page| page.text }
        #puts page_contents.inspect

        # Buscar y extraer los datos específicos de la página
        no_oficio=""
        asunto = ""
        plan=""
        nombre = ""
        numero_de_control = ""
        carrera = ""
        nivel=""
        periodo=""
        fecha=""
        cadena_comprobacion=""

        page_contents.each do |content|

          if content.include?("No.")
            no_oficio = content[/No.\s*(.*)/, 1].strip
          end

          if content.include?("ASUNTO:")
            asunto = content[/ASUNTO:\s*(.*)/, 1].strip
          end

          if content.include?("con registro vigente")
            plan = content[/vigente\s*(.*?)\s*,/, 1].strip
          end
         

          if content.include?("C.")
            nombre= content[/C\.\s*([^,]*)/, 1].strip
            
          end
         
          if content.include?("control")
            numero_de_control= content[/control\s*(.*?)\s*,/, 1].strip
            
          end
         

          if content.include?("de la carrera")
            carrera = content[/carrera\s*(.*?)\s*,/, 1].strip
            
          end

          if content.include?("nivel de")
            nivel= content[/(?<=nivel de\s)[^\s]+/]
          end
         
        
          if content.include?("periodo")
            periodo = content[/periodo\s*(.*)/, 1].strip
          
          end

          if content.include?("el día")
            fecha = content[/día\s*([^.]*)/, 1].strip
            fecha = DateTime.parse(fecha).strftime('%Y-%m-%d %H:%M:%S')
  
            # Convertir la cadena de texto a un objeto DateTime
          
          end          

          if content.include?("CADENA DE COMPROBACIÓN:")
            cadena_comprobacion = content[/COMPROBACIÓN:\s*(.*)/, 1].strip
          end
        end
        
        # Crear un documento XML con Nokogiri
        
        builder = Nokogiri::XML::Builder.new do |xml|
          xml.file {
            xml.filename blob.filename
              xml.constancia {
              xml.serial serial
              xml.no_oficio no_oficio
              xml.asunto asunto
              xml.plan plan
              xml.nombre nombre
              xml.numero_de_control numero_de_control
              xml.carrera carrera
              xml.nivel nivel
              xml.periodo periodo
              xml.fecha fecha
              xml.md5 md5
              xml.cadena_comprobacion cadena_comprobacion
              
              
              
            }
          }
        end

        # Crear un nuevo objeto Documento y asignarle los valores
       
        @documento.serial = serial
        @documento.no_oficio = no_oficio
        @documento.asunto = asunto
        @documento.plan = plan
        @documento.nombre = nombre
        @documento.numero_de_control = numero_de_control
        @documento.carrera = carrera
        @documento.nivel = nivel
        @documento.periodo = periodo
        @documento.fecha = fecha
        @documento.md5 = md5
        @documento.cadena_comprobacion = cadena_comprobacion
  
        # Guardar los cambios en la base de datos
        @documento.save
     if @documento.save

# Guardar el documento XML en un archivo
File.open(Rails.root.join('public', 'uploads', "#{nombre}.xml"), "w") do |file|
 
 file.write(builder.to_xml(encoding: 'UTF-8'))
 file.close

end
checksum_actual = Digest::MD5.file(Rails.root.join('public', 'uploads', "#{nombre}.xml")).hexdigest
if checksum_actual == md5
  puts checksum_actual
  puts "El archivo XML ha sido guardado correctamente y su checksum es igual al valor en la base de datos."
else
  puts "Error: el archivo XML ha sido guardado correctamente pero su checksum es diferente al valor en la base de datos."
  puts checksum_actual
end
end
        format.html { redirect_to documento_url(@documento), notice: "Documento was successfully created." }
        format.json { render :show, status: :created, location: @documento }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @documento.errors, status: :unprocessable_entity }
      end
    end
  end
 
  
  # PATCH/PUT /documentos/1 or /documentos/1.json
  def update
    respond_to do |format|
      if @documento.update(documento_params)
        format.html { redirect_to documento_url(@documento), notice: "Documento was successfully updated." }
        format.json { render :show, status: :ok, location: @documento }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @documento.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /documentos/1 or /documentos/1.json
  def destroy
    @documento.destroy

    respond_to do |format|
      format.html { redirect_to documentos_url, notice: "Documento was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_documento
      @documento = Documento.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def documento_params
      params.require(:documento).permit(:user_id,:pdf_path, uploads: [])
    end




    # def view_pdf
    #   @documento = Documento.find(params[:id])
    #   pdf_path = @documento.uploads.first.service_url
    #   send_file pdf_path, type: 'application/pdf', disposition: 'inline'
    # end
    





    # def view_pdf
    #   # Obtener el valor del código de barras desde el parámetro de la URL
    #   serial = params[:serial]
    
    #   # Buscar el documento correspondiente al código de barras
    #   documento = Documento.find_by(serial: serial)
    
    #   if documento
    #     # Obtener el primer objeto ActiveStorage::Blob asociado a este documento
    #     blob = documento.uploads.first.blob
    
    #     if blob
    #       # Obtener la URL de descarga del archivo
    #       url = url_for(blob)
    
    #       # Redirigir al usuario a la URL para descargar y visualizar el archivo
    #       redirect_to url and return
    #     end
    #   end
    
    #   # Si no se encuentra el documento o el archivo no existe, mostrar un mensaje de error
    #   flash[:error] = "El archivo correspondiente al código de barras #{serial} no se ha encontrado."
    #   redirect_to root_path
    # end
    
    def read_barcode
      codigo_barras = # Leer código de barras
      redirect_to view_pdf_path(codigo_barras)
    end



    def view_pdf
      # Busca el documento correspondiente al código de barras
      @documento = Documento.find_by(serial: params[:serial])
      # Redirige al usuario a la vista que muestra el PDF si se encontró el documento
      if @documento.present?
        redirect_to rails_blob_path(@documento.archivo, disposition: 'inline')
      else
        # Si no se encontró el documento, muestra un mensaje de error
        flash[:error] = 'El documento no fue encontrado'
        redirect_to documentos_path
      end
    end
  
    
end
