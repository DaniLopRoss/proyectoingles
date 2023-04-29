require "test_helper"

class DocumentoTest < ActiveSupport::TestCase
  include ActionDispatch::TestProcess
 
  def setup
    @user = User.create(email: "test@example.com", password: "password")
    @doc = Documento.new(numero_de_control: "18161003", user: @user)
    @file = fixture_file_upload('CLE_0004202318161003.pdf', 'application/pdf')
  end

  test "numero_de_control should be present" do
    @doc.numero_de_control = "18161003"
    assert_not @doc.valid?
  end

  test "numero_de_control should be unique" do
    @doc.save
    doc2 = Documento.new(numero_de_control: "18161003", user: @user)
    assert_not doc2.valid?
  end

  test "archivo_pdf should be attached" do
    assert_not @doc.archivo_pdf.attached?
    @doc.archivo_pdf.attach(@file)
    assert @doc.archivo_pdf.attached?
  end

  test "uploads should be present" do
    @doc = Documento.new(numero_de_control: "18161003", user: @user)
    assert_not @doc.valid?
    assert_equal ["necesita adjuntar un documento"], @doc.errors.messages[:uploads]
  end
  



  def test_sin_pago_muestra_solo_documentos_sin_pago
    # Crear algunos documentos con pagos asociados
    documento1 = Documento.create(serial: "0004202318161003",no_oficio: "DGTV-CLE-0004/2023", asunto: "Constancia de Acreditación del Idioma Inglés.", plan:"TecNM-SEyV-DVIA-CNLE-ACT-03/21-ITO-32", nombre: "MARCOS ÁNGEL JMICA", numero_de_control: "17161155", carrera:"Sistemas", nivel: "B1", periodo: "agosto-diciembre de 2022.", md5: "8TWlNFJrSmL", cadena_comprobacion: "DGTV_CLE_0001_2023_17160858_0001202317160858_186.96.178.153_2023_03_14_19_58_09", fecha:"2023-03-01", user_id: 980190962, referencia:"CLE_0001202317160858.pdf")
    documento2 = Documento.create(serial: "0004202318161003",no_oficio: "DGTV-CLE-0004/2023", asunto: "Constancia de Acreditación del Idioma Inglés.", plan:"TecNM-SEyV-DVIA-CNLE-ACT-03/21-ITO-32", nombre: "JUAN ÁNGEL GOMEZ", numero_de_control: "17161122", carrera:"Sistemas", nivel: "B1", periodo: "agosto-diciembre de 2022.", md5: "8TWlNFJrSmL", cadena_comprobacion: "DGTV_CLE_0001_2023_17160858_0001202317160858_186.96.178.153_2023_03_14_19_58_09", fecha:"2023-03-01", user_id: 980190962, referencia:"CLE_0001202317160858.pdf")
    pago1 = Payment.create(nombre: "Pago1", status: "Pagado", documento_id: documento1.id, user_id: 980190962)
    pago2 = Payment.create(nombre: "Pago2", status: "Pendiente", documento_id: documento2.id, user_id: 980190962)
    
# Asociar un pago al documento1

    
    # Crear algunos documentos sin pagos asociados
    documento3 = Documento.create(serial: "0004202318161003",no_oficio: "DGTV-CLE-0004/2023", asunto: "Constancia de Acreditación del Idioma Inglés.", plan:"TecNM-SEyV-DVIA-CNLE-ACT-03/21-ITO-32", nombre: "DANIEL LOPEZ", numero_de_control: "17161155", carrera:"Sistemas", nivel: "B1", periodo: "agosto-diciembre de 2022.", md5: "8TWlNFJrSmL", cadena_comprobacion: "DGTV_CLE_0001_2023_17160858_0001202317160858_186.96.178.153_2023_03_14_19_58_09", fecha:"2023-03-01", user_id: 980190962, referencia:"CLE_0001202317160858.pdf")
    documento4 = Documento.create(serial: "0004202318161003",no_oficio: "DGTV-CLE-0004/2023", asunto: "Constancia de Acreditación del Idioma Inglés.", plan:"TecNM-SEyV-DVIA-CNLE-ACT-03/21-ITO-32", nombre: "MARTHA JUAREZ SANCHEZ", numero_de_control: "17161155", carrera:"Sistemas", nivel: "B1", periodo: "agosto-diciembre de 2022.", md5: "8TWlNFJrSmL", cadena_comprobacion: "DGTV_CLE_0001_2023_17160858_0001202317160858_186.96.178.153_2023_03_14_19_58_09", fecha:"2023-03-01", user_id: 980190962, referencia:"CLE_0001202317160858.pdf")
  
 # Imprimir los pagos asociados a cada documento para verificar que los documentos 1 y 2 tienen pagos
 #puts "Pagos del documento 1: #{documento1.payment}"
 #puts "Pagos del documento 2: #{documento2.payment}"

    documentos_sin_pago = Documento.sin_pago

    documentos_sin_pago = [documento3, documento4]

    # Ejecutar el método sin_pago
 # Crear dos documentos sin pagos asociados
#  documento5 = Documento.create(serial: "0004202318161003",no_oficio: "DGTV-CLE-0004/2023", asunto: "Constancia de Acreditación del Idioma Inglés.", plan:"TecNM-SEyV-DVIA-CNLE-ACT-03/21-ITO-32", nombre: "DANIEL LOPEZ", numero_de_control: "17161155", carrera:"Sistemas", nivel: "B1", periodo: "agosto-diciembre de 2022.", md5: "8TWlNFJrSmL", cadena_comprobacion: "DGTV_CLE_0001_2023_17160858_0001202317160858_186.96.178.153_2023_03_14_19_58_09", fecha:"2023-03-01", user_id: 980190962, referencia:"CLE_0001202317160858.pdf")
#  documento6 = Documento.create(serial: "0004202318161003",no_oficio: "DGTV-CLE-0004/2023", asunto: "Constancia de Acreditación del Idioma Inglés.", plan:"TecNM-SEyV-DVIA-CNLE-ACT-03/21-ITO-32", nombre: "MARTHA JUAREZ SANCHEZ", numero_de_control: "17161155", carrera:"Sistemas", nivel: "B1", periodo: "agosto-diciembre de 2022.", md5: "8TWlNFJrSmL", cadena_comprobacion: "DGTV_CLE_0001_2023_17160858_0001202317160858_186.96.178.153_2023_03_14_19_58_09", fecha:"2023-03-01", user_id: 980190962, referencia:"CLE_0001202317160858.pdf")

# # Obtener la lista de documentos sin pago
# documentos_sin_pago = Documento.sin_pago

# # Verificar que los documentos sin pago incluyen a los documentos creados anteriormente
# assert_includes(documentos_sin_pago, documento5)
# assert_includes(documentos_sin_pago, documento6)

  
     # Imprimir los documentos obtenidos por el método sin_pago para verificar que solo se muestren los documentos sin pago
  #puts "Documentos sin pago: #{documentos_sin_pago.to_a}"
    # Verificar que solo se muestren los documentos sin pago
    
    assert_includes(documentos_sin_pago, documento3)
    assert_includes(documentos_sin_pago, documento4)
    refute_includes(documentos_sin_pago, documento1)
    refute_includes(documentos_sin_pago, documento2)

  end
  
  




# test "documento sin pago muestra solo documentos sin pago" do
#   documento_sin_pago = Documento.create(serial: "0004202318161003",no_oficio: "DGTV-CLE-0004/2023", asunto: "Constancia de Acreditación del Idioma Inglés.", plan:"TecNM-SEyV-DVIA-CNLE-ACT-03/21-ITO-32", nombre: "MARCOS ÁNGEL JMICA", numero_de_control: "17161155", carrera:"Sistemas", nivel: "B1", periodo: "agosto-diciembre de 2022.", md5: "8TWlNFJrSmL", cadena_comprobacion: "DGTV_CLE_0001_2023_17160858_0001202317160858_186.96.178.153_2023_03_14_19_58_09", fecha:"2023-03-01", user_id: 980190962, referencia:"CLE_0001202317160858.pdf")
#   documento_con_pago = Documento.create(serial: "0004202318161003",no_oficio: "DGTV-CLE-0004/2023", asunto: "Constancia de Acreditación del Idioma Inglés.", plan:"TecNM-SEyV-DVIA-CNLE-ACT-03/21-ITO-32", nombre: "JUAN ÁNGEL GOMEZ", numero_de_control: "17161122", carrera:"Sistemas", nivel: "B1", periodo: "agosto-diciembre de 2022.", md5: "8TWlNFJrSmL", cadena_comprobacion: "DGTV_CLE_0001_2023_17160858_0001202317160858_186.96.178.153_2023_03_14_19_58_09", fecha:"2023-03-01", user_id: 980190962, referencia:"CLE_0001202317160858.pdf")
#   pago1 = Payment.create(nombre: "Pago1", status: "Pagado", documento_id: documento_con_pago.id, user_id: 980190962)
#   documentos_sin_pago = Documento.sin_pago
#   puts "Pagos del documento: #{documento_con_pago.payment}"
#   puts "Documentos sin pago: #{documentos_sin_pago.to_a}"
#   assert_includes documentos_sin_pago, documento_sin_pago
#   refute_includes documentos_sin_pago, documento_con_pago
# end


  
  
end
