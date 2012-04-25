class Ability
  include CanCan::Ability

  def initialize(user)

    # handle case where user is not yet logged in
    user ||= User.new # guest user
   
    # admins can do anything
    if user.employee.role == "admin"
        can :manage, :all
        
    # managers can access and edit
    # - their information
    # - their employees' information
    # and they can create and edit
    # - shifts and jobs
    elsif user.employee.role == "manager"
        can :update, Employee do |employee|
            (employee.id == user.employee.id) || (Employee.by_store(user.employee.store).include?(employee.id))
        end
        can :manage, Shift
        can :manage, Job
        
    # employees can only see their own info,
    # but they can't modify it
    elsif user.employee.role == "employee"
        can :read, Employee do |employee|
            employee.id == user.employee.id
        end
    end
    
    # The first argument to `can` is the action you are giving the user permission to do.
    # If you pass :manage it will apply to every action. Other common actions here are
    # :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on. If you pass
    # :all it will apply to every resource. Otherwise pass a Ruby class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details: https://github.com/ryanb/cancan/wiki/Defining-Abilities
  end
end
