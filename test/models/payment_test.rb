require "test_helper"

class PaymentTest < ActiveSupport::TestCase
  test "payment without certificate" do
    payment = Payment.new
    assert payment.valid?

    payment.save!

    assert_includes Payment.sin_certificado, payment
  end
end
