require 'test_helper'

class DocumentoUploadTest < ActionController::TestCase
  fixtures :users
  setup do
    @users = users(:one)
    
  end

  test "usuario carga un documento inválido" do
    # Iniciar sesión
    post :create, params: {
      user: {
        email: @users.email,
        password: "password"
      }
    }

    # Acceder a la página de carga de documentos
    get :new

    # Simular una petición HTTP POST a la ruta '/documentos' con un archivo inválido
    post :create, params: {
      documento: {
        uploads: fixture_file_upload('documentos/COMPROBANTE_REFERENCIA_PAGO_10000.pdf', 'application/pdf')
      }
    }

    # Comprobar que la respuesta HTTP tenga el código 422 (unprocessable entity)
    assert_response 422

    # Comprobar que la página muestra un mensaje de error indicando que el archivo es inválido
    assert_select 'div#error_explanation', text: /Archivo no válido/
  end
end
