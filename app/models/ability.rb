class Ability
  include CanCan::Ability

  def initialize(users)
    user ||= User.new
    if user.role == "administrador"
      can :manage, :all
    elsif user.role == "ingles"
      alias_action :create, :read, :update, :to => :cru
          can :cru, Documento, expect:[:destroy, :payment]
          cannot :manage, Payment
          cannot :manage, Certificate
    elsif user.role == "financieros"
      alias_action :create, :read, :update, :to => :cru
              can: cru, Payment, expect: [:destroy, :certificate]
              cannot :manage, Documento
              cannot :manage, Certificate
    elsif user.role == "escolares"
      can :read , Phyment, except: [:edit, :update, :destroy]
       can :read, Documento, except: [:edit, :update, :destroy]
            
      elsif user.role== "direccion"
        
        alias_action :create, :read, :update, :to => :cru
        can :cru, Certificate
        
     end
    end
   end