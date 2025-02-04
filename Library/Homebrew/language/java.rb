# typed: true
# frozen_string_literal: true

module Language
  # Helper functions for Java formulae.
  #
  # @api public
  module Java
    def self.find_openjdk_formula(version = nil)
      can_be_newer = version&.end_with?("+")
      version = version.to_i

      openjdk = Formula["openjdk"]
      [openjdk, *openjdk.versioned_formulae].find do |f|
        next false unless f.any_version_installed?

        unless version.zero?
          major = f.any_installed_version.major
          next false if major < version
          next false if major > version && !can_be_newer
        end

        true
      end
    rescue FormulaUnavailableError
      nil
    end
    private_class_method :find_openjdk_formula

    def self.java_home(version = nil)
      find_openjdk_formula(version)&.opt_libexec
    end

    def self.java_home_shell(version = nil)
      java_home(version).to_s
    end
    private_class_method :java_home_shell

    def self.short_java_home_shell(version = nil)
      Utils.shortened_brew_path(java_home(version))
    end
    private_class_method :short_java_home_shell

    def self.java_home_env(version = nil)
      { JAVA_HOME: java_home_shell(version) }
    end

    def self.short_java_home_env(version = nil)
      { JAVA_HOME: short_java_home_shell(version) }
    end

    def self.overridable_java_home_env(version = nil)
      { JAVA_HOME: "${JAVA_HOME:-#{java_home_shell(version)}}" }
    end

    def self.overridable_short_java_home_env(version = nil)
      { JAVA_HOME: "${JAVA_HOME:-#{short_java_home_shell(version)}}" }
    end
  end
end

require "extend/os/language/java"
