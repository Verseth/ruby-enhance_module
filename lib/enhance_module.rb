# frozen_string_literal: true
# typed: true

require "sorbet-runtime"
require_relative "enhance_module/version"

# This module can be included in the singleton class of a module
# to make it able to extend objects in a typed, sorbet-friendly way.
#
#     require "enhance_module"
#
#     module MyModule
#       extend T::Sig
#
#       class << self
#         extend T::Generic
#         include EnhanceModule
#         has_attached_class! { { fixed: MyModule } }
#       end
#
#       sig { void }
#       def my_module_method; end
#     end
#
#     class MyClass
#       extend T::Sig
#
#       sig { void }
#       def my_class_method; end
#     end
#
#     obj = MyClass.new
#     obj.my_class_method # ok!
#
#     # extend the object with `MyModule`
#     extended_obj = MyModule.enhance(obj)
#     extended_obj.my_class_method  # ok!
#     extended_obj.my_module_method # ok!
#
module EnhanceModule
  extend T::Sig
  extend T::Generic
  has_attached_class!

  sig do
    type_parameters(:T)
      .params(obj: T.type_parameter(:T))
      .returns(T.all(T.attached_class, T.type_parameter(:T)))
  end
  def enhance(obj)
    T.unsafe(obj).extend(self)
  end

  module ClassMethods
    include T::Sig
    include T::Generic
  end
  mixes_in_class_methods(ClassMethods)
end
