require "test_helper"

class DocumentoTest < ActiveSupport::TestCase
  def setup
    @user = User.create(email: "user@example.com", password: "password")
  end

  test "documento should belong to user" do
    documento = Documento.new(user: @user)
    assert_equal @user, documento.user
  end

  test "documento should have one payment" do
    documento = Documento.new
    assert_respond_to documento, :payment
  end

  test "documento should have one attached pdf file" do
    documento = Documento.new
    assert_respond_to documento, :archivo_pdf
  end

  test "documento should have many attached uploads" do
    documento = Documento.new
    assert_respond_to documento, :uploads
  end

  test "documento should validate uniqueness of numero_de_control" do
    Documento.create(numero_de_control: "123456")
    documento = Documento.new(numero_de_control: "123456")
    refute documento.valid?
    assert_includes documento.errors[:numero_de_control], "ya existe en la base de datos"
  end

  test "uploads should start with prefix 'CLE_'" do
    documento = Documento.new
    upload = documento.uploads.attach(io: File.open(Rails.root.join("test/fixtures/files/CLE_test.pdf")), filename: "CLE_test.pdf")
    documento.file_name_start_with_prefix
    assert_empty documento.errors[:uploads]
  end

  test "uploads should not have duplicate file names" do
    documento1 = Documento.create
    documento1.uploads.attach(io: File.open(Rails.root.join("test/fixtures/files/CLE_test.pdf")), filename: "CLE_test.pdf")
    documento2 = Documento.create
    documento2.uploads.attach(io: File.open(Rails.root.join("test/fixtures/files/CLE_test.pdf")), filename: "CLE_test.pdf")
    documento2.unique_file_names
    refute_empty documento2.errors[:uploads]
  end

  test "sin_pago returns documentos without associated payment" do
    documento_without_payment = Documento.create
    payment = Payment.create(documento: documento_without_payment)
    documento_with_payment = Documento.create(payment: payment)

    assert_includes Documento.sin_pago, documento_without_payment
    refute_includes Documento.sin_pago, documento_with_payment
  end
end
