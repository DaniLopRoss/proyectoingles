class CertificatesController < ApplicationController
  before_action :set_certificate, only: %i[ show edit update destroy ]

  # GET /payments or /payments.json
  def index
    @certificates = Certificate.all
  end

  # GET /payments/1 or /payments/1.json
  def show
  end

  # GET /payments/new
  def new
    @certificate = Certificate.new
    @payment = Payment.find(params[:payment_id])
  end

  # GET /payments/1/edit
  def edit
  end

  # POST /payments or /payments.json
  def create
    
    @certificate = Certificate.new(certificate_params)
    @certificate.payment_id = params[:certificate][:payment_id]


    if @certificate.save
      redirect_to certificate_path(@certificate), notice: "El pago ha sido agregado con éxito."
      #redirect_to document_path(@payment.documento), notice: "El pago ha sido agregado con éxito."
    else
      render :new
    end

    # respond_to do |format|
    #   if @payment.save
    #     format.html { redirect_to payment_url(@payment), notice: "Payment was successfully created." }
    #     format.json { render :show, status: :created, location: @payment }
    #   else
    #     format.html { render :new, status: :unprocessable_entity }
    #     format.json { render json: @payment.errors, status: :unprocessable_entity }
    #   end
    # end
  end

  # PATCH/PUT /payments/1 or /payments/1.json
  def update
    respond_to do |format|
      if @certificate.update(certificate_params)
        format.html { redirect_to certificate_url(@certificate), notice: "Certificate was successfully updated." }
        format.json { render :show, status: :ok, location: @certificate}
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
      format.html { redirect_to certificate_url, notice: "Certificate was successfully destroyed." }
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
      params.require(:certificate).permit(:nombre, :payment_id, uploads: [])
    end
end