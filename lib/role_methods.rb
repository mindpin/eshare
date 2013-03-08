module RoleMethods
  extend ActiveSupport::Concern

  included do
    ROLES = %w[admin manager teacher student]
    ROLE_NAMES = %w[系统管理员 教学管理员 老师 学生]

    FIELD = :roles_mask

    scope :with_role, lambda { |role| 
      {:conditions => ['? & ? > 0', FIELD, 2 ** ROLES.index(role.to_s)]}
    }

    ROLES.each do |role|
      define_method "is_#{role}?" do
        role? role
      end
    end
  end

  module InstanceMethods
    def roles
      ROLES.reject { |role| 
        ((self[FIELD] || 0) & 2 ** ROLES.index(role)).zero?
      }
    end

    def role?(role)
      self.roles.include? role.to_s
    end

    def set_role(role)
      self.roles = (ROLES & [role.to_s])
      save
    end

    def role_str
      ROLE_NAMES[ROLES.index(roles.first)]
    end

    private

      def roles=(roles)
        self[FIELD] = (ROLES & roles).map { |role| 
          2 ** ROLES.index(role) 
        }.sum
      end
  end

end