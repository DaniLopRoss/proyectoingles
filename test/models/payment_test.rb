require 'test_helper'

class PaymentTest < ActiveSupport::TestCase
  test "payment is valid with unique name" do
    payment = Payment.new(nombre: "Unique name")
    assert payment.valid?
  end

  test "payment is invalid with non-unique name" do
    existing_payment = Payment.create(nombre: "Existing name")
    duplicate_payment = Payment.new(nombre: "Existing name")

    assert_not duplicate_payment.valid?
    assert_includes duplicate_payment.errors[:nombre], "has already been taken"
  end

  test "payment belongs to a documento" do
    payment = Payment.new
    assert_respond_to payment, :documento
  end

  test "payment has many attached uploads" do
    payment = Payment.new
    assert_respond_to payment, :uploads
  end

  test "payment has one certificate" do
    payment = Payment.new
    assert_respond_to payment, :certificate
  end

  test "sin_certificado returns payments without certificate_id" do
    payment_without_certificate = Payment.create
    payment_with_certificate = Payment.create(certificate_id: 14)

    assert_includes Payment.sin_certificado, payment_without_certificate
    refute_includes Payment.sin_certificado, payment_with_certificate
  end
end
