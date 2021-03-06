# frozen_string_literal: true

if Lite::Ruby.configuration.monkey_patches.include?('object')
  class Object

    FALSE_VALUES ||= %w[
      0 f false n no off
    ].freeze
    TRUE_VALUES ||= %w[
      1 t true y yes on
    ].freeze

    def array?
      is_a?(Array)
    end

    def blank?
      object = self
      object = object.strip if respond_to?(:strip)
      return object.empty? if respond_to?(:empty?)

      !object
    end

    def bool?
      true? || false?
    end

    def boolean?
      val = to_s.downcase
      TRUE_VALUES.include?(val) || FALSE_VALUES.include?(val)
    end

    def date?
      is_a?(Date)
    end

    def deep_dup
      duplicable? ? dup : self
    end

    def duplicable?
      true
    end

    # rubocop:disable Style/YodaCondition
    def false?
      false == self
    end
    # rubocop:enable Style/YodaCondition

    def falsey?
      nil? || FALSE_VALUES.include?(to_s.downcase)
    end

    def float?
      is_a?(Float)
    end

    def hash?
      is_a?(Hash)
    end

    def integer?
      is_a?(Integer)
    end

    # rubocop:disable Naming/PredicateName
    def is_any?(*objs)
      objs.any? { |obj| is_a?(obj) }
    end
    # rubocop:enable Naming/PredicateName

    def numeral?
      !to_s.match(/\A[+-]?\d+?(\.\d+)?\Z/).nil?
    end

    def numeric?
      is_a?(Numeric)
    end

    def open_struct?
      is_a?(OpenStruct)
    end

    def palindrome?
      to_s == to_s.reverse
    end

    def present?
      !blank?
    end

    def presence
      self if present?
    end

    def range?
      is_a?(Range)
    end

    def safe_call(*keys)
      try_call(*keys) || self
    end

    def safe_send(*keys)
      try_send(*keys) || self
    end

    def safe_try(*obj, &block)
      try(*obj, &block) || self
    end

    def salvage(placeholder = '---')
      blank? ? placeholder : self
    end

    def salvage_try(*obj, placeholder: '---', &block)
      try(*obj, &block).salvage(placeholder)
    end

    def send_chain(*keys)
      Array(keys).inject(self) { |obj, key| obj.send(*key) }
    end

    def send_chain_if(*keys)
      Array(keys).inject(self) { |obj, key| obj.send_if(*key) }
    end

    def send_if(key, *args)
      return self unless respond_to?(key)

      send(key, *args)
    end

    def set?
      is_a?(Set)
    end

    def string?
      is_a?(String)
    end

    def struct?
      is_a?(Struct)
    end

    def symbol?
      is_a?(Symbol)
    end

    def time?
      is_a?(Time)
    end

    def to_bool
      return true if truthy?
      return false if falsey?

      nil
    end

    alias to_b to_bool

    # rubocop:disable Style/YodaCondition
    def true?
      true == self
    end
    # rubocop:enable Style/YodaCondition

    def truthy?
      TRUE_VALUES.include?(to_s.downcase)
    end

    def try(*obj, &block)
      try!(*obj, &block) if obj.empty? || respond_to?(obj.first)
    end

    def try!(*obj, &block)
      if obj.empty? && block_given?
        block.arity.zero? ? instance_eval(&block) : yield(self)
      else
        public_send(*obj, &block)
      end
    end

    def try_call(*keys)
      return unless respond_to?(:call)

      keys.blank? ? call : call(*keys)
    end

    def try_send(*keys)
      send(*keys)
    rescue StandardError
      nil
    end

  end
end
