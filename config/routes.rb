Rails.application.routes.draw do
  resources :certificates
  resources :payments
  resources :referencia
  resources :anexos


  resources :file_uploads
  resources :archivos
  post 'archivos/subir_archivo' => 'archivos#subir_archivo'

  resources :documentos
  get '/descargar_pdf', to: 'documentos#descargar_pdf'
  get 'ingles', to: 'home#ingles'
  get 'financieros', to: 'home#financieros'
  get 'direccion', to: 'home#direccion'
  get 'servicios', to: 'home#serviciosescolares'
  root to: 'home#index'
  #get 'documentos/:id/download', to: 'documentos#download', as: 'download_documento'

  resources :documentos 
  




  devise_for :user
  authenticated :user do
    root 'home#index', as: :admin_root
  end
  
  authenticated :ingles do
    root 'home#ingles', as: :ingles_root
  end
  
  authenticated :financieros do
    root 'home#financieros', as: :financieros_root
  end
  authenticated :servicios do
    root 'home#serviciosescolares', as: :servicios_root
  end

  devise_scope :devise do 
    get 'signup', to: 'devise/registrations#new'
    get 'sign_in', to: 'devise/sessions#new'
    get 'signout', to: 'devise/sessions#destroy'
  end 

  

 
  
  
   
    
end

