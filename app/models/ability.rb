class Ability
  include CanCan::Ability

  def initialize(user)

    # handle case where user is not yet logged in
    user ||= User.new # guest user
   
    # admins can do anything
    if user.role == "admin"
        can :manage, :all
        
    elsif user.role == "manager"
        # managers can access and edit
        # - their information
        # - their employees' information
        can [:show, :update], Employee do |employee|
            (employee.id == user.employee_id) || (Employee.by_store(user.employee.store).include?(employee.id))
        end
        cannot :create, Employee
        cannot :destroy, Employee
                
        # can do anything with Shifts
        can :manage, Shift
        
        # can't look at or do anything with stores
        
        # can't do anything with assignments
        cannot :manage, Assignment
        
        # can create and edit jobs related to Shifts
        can [:create, :edit], Job
        
        # can't manage users
        cannot :manage, User
        
    elsif user.employee.role == "employee"
        # employees can only see their own info
        can :read, Employee do |employee|
            employee.id == user.employee_id
        end

        # can :show, Shift do |employee|
            

        # can't do anything else
        cannot :manage, [Store, Job, Assignment, User]
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
