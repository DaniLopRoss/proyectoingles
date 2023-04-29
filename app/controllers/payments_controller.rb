class PaymentsController < ApplicationController
  before_action :set_payment, only: %i[ show edit update destroy ]

  # GET /payments or /payments.json
  def index
    if current_user.role == "financieros"|| current_user.role == "servicios"
      @payments = Payment.all
    elsif current_user.role == "direccion"
      @payments = Payment.left_outer_joins(:certificate).where(certificate: { status: nil })
    else
      @payments = []
    end
  end
  

  # GET /payments/1 or /payments/1.json
  def show
  end

  # GET /payments/new
  def new
    @payment = Payment.new
    @documento = Documento.find(params[:documento_id])
  end

  # GET /payments/1/edit
  def edit
  end

  # POST /payments or /payments.json
  def create
    
    @payment = Payment.new(payment_params)
    @payment.documento_id = params[:payment][:documento_id]
    @payment.user = current_user

    logger.debug("Documento ID: #{params[:payment][:documento_id]}")
    
    if @payment.save
      blob = @payment.uploads.first.blob
      nombre=blob.filename
      @payment.nombre = nombre
      @payment.save
      redirect_to payment_path(@payment), notice: "El pago ha sido agregado con éxito."
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
      if @payment.update(payment_params)
        format.html { redirect_to payment_url(@payment), notice: "Payment was successfully updated." }

        format.json { render :show, status: :ok, location: @payment }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @payment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /payments/1 or /payments/1.json
  def destroy
    @payment.destroy

    respond_to do |format|
      format.html { redirect_to payments_url, notice: "Payment was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_payment
      @payment = Payment.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def payment_params
      params.require(:payment).permit(:user_id,:nombre, :status, :documento_id, uploads: [])
    end
end