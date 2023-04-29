class CertificatesController < ApplicationController
  before_action :set_certificate, only: %i[ show edit update destroy ]

  # GET /payments or /payments.json
  def index
  
      @certificates = Certificate.all
  end

  # GET /payments/1 or /payments/1.json
  def show
    @certificate = Certificate.includes(:documento).find(params[:id])
  end

  # GET /certificates/new
  def new
    @certificate = Certificate.new
    @payment = Payment.find(params[:payment_id])
  end
  def update_status
    @certificate = Certificate.find(params[:id])
    @certificate.update(status: true)
    redirect_to @certificate.payment
  end
  # GET /payments/1/edit
  def edit
  end

  # POST /payments or /payments.json
  def create
    
    @certificate = Certificate.new(certificate_params)
    @certificate.payment_id = params[:certificate][:payment_id]
    @certificate.user = current_user

    logger.debug("Payment ID: #{params[:certificate][:payment_id]}")

    if @certificate.save
      blob = @certificate.uploads.first.blob
      nombre=blob.filename
      @certificate.nombre = nombre
      @certificate.save
      redirect_to certificate_path(@certificate), notice: "La firma ha sido agregado con éxito."

      else
        flash[:error] = "El archivo ya existe"
      render :new
    end
  end

  # PATCH/PUT /payments/1 or /payments/1.json
  def update
    respond_to do |format|
      if @certificate.update(certificate_params)
        format.html { redirect_to certificate_url(@certificate), notice: "Certtificate was successfully updated." }
        format.json { render :show, status: :ok, location: @certificate }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @certificate.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /payments/1 or /payments/1.json
  def destroy
    @certificate.destroy

    respond_to do |format|
      format.html { redirect_to certificates_url, notice: "Certificate was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_certificate
      @certificate = Certificate.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def certificate_params
      params.require(:certificate).permit(:user_id, :nombre, :payment_id, :status, uploads: [])
    end
end