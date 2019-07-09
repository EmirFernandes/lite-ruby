# frozen_string_literal: true

class Array

  unless defined?(after)
    def after(value)
      return unless include?(value)

      self[(index(value).to_i + 1) % length]
    end
  end

  unless defined?(before)
    def before(value)
      return unless include?(value)

      self[(index(value).to_i - 1) % length]
    end
  end

  # rubocop:disable Metrics/AbcSize, Metrics/BlockNesting, Metrics/MethodLength
  # rubocop:disable Metrics/PerceivedComplexity, Style/GuardClause, Style/IfInsideElse
  unless defined?(bury)
    def bury(*args)
      if args.count < 2
        raise ArgumentError, '2 or more arguments required'
      elsif args.count == 2
        if args[0].is_a?(Integer)
          self[args[0]] = args[1]
        else
          self << { args[0] => args[1] }
        end
      else
        if args[0].is_a?(Integer)
          arg = args.shift

          self[arg] = [] unless self[arg]
          self[arg].bury(*args)
        else
          self << {}.bury(*args)
        end
      end

      self
    end
  end
  # rubocop:enable Metrics/PerceivedComplexity, Style/GuardClause, Style/IfInsideElse
  # rubocop:enable Metrics/AbcSize, Metrics/BlockNesting, Metrics/MethodLength

  unless defined?(delete_first)
    def delete_first
      self[1..-1]
    end
  end

  unless defined?(delete_first!)
    def delete_first!
      replace(delete_first)
    end
  end

  unless defined?(delete_last)
    def delete_last
      self[0...-1]
    end
  end

  unless defined?(delete_last!)
    def delete_last!
      replace(delete_last)
    end
  end

  unless defined?(delete_values)
    def delete_values(*args)
      args.each_with_object([]) { |val, results| results << delete(val) }
    end
  end

  unless defined?(demote)
    def demote(value)
      sort_by { |val| val == value ? 0 : -1 }
    end
  end

  unless defined?(demote!)
    def demote!(value)
      replace(demote(value))
    end
  end

  unless defined?(denillify)
    def denillify(value = 0)
      map { |val| val.nil? ? value : val }
    end
  end

  unless defined?(denillify!)
    def denillify!(value = 0)
      replace(denillify(value))
    end
  end

  unless defined?(dig)
    def dig(key, *rest)
      value = (begin
                 self[key]
               rescue StandardError
                 nil
               end)

      return if value.nil?
      return value if rest.empty?
      return value.dig(*rest) if value.respond_to?(:dig)
    end
  end

  unless defined?(duplicates)
    def duplicates(minimum = 2)
      hash = ::Hash.new(0)
      each { |val| hash[val] += 1 }
      hash.delete_if { |_, val| val < minimum }.keys
    end
  end

  unless defined?(from)
    def from(position)
      self[position, length] || []
    end
  end

  unless defined?(fulfill)
    def fulfill(value, amount)
      return self if amount <= length

      fill(value, length..(amount - 1))
    end
  end

  unless defined?(groups)
    def groups(number)
      return [] if number <= 0

      num, rem = length.divmod(number)
      collection = (0..(num - 1)).collect { |val| self[(val * number), number] }
      rem.positive? ? collection << self[-rem, rem] : collection
    end
  end

  # rubocop:disable Metrics/MethodLength, Metrics/CyclomaticComplexity, Metrics/AbcSize
  unless defined?(in_groups)
    def in_groups(number, fill_with = nil)
      collection_length = length
      division = collection_length.div(number)
      modulo = collection_length % number

      collection = []
      start = 0
      number.times do |int|
        mod_gt_zero = modulo.positive?
        grouping = division + (mod_gt_zero && modulo > int ? 1 : 0)
        collection << last_group = slice(start, grouping)
        last_group << fill_with if fill_with != false && mod_gt_zero && grouping == division
        start += grouping
      end

      block_given? ? collection.each { |val| yield(val) } : collection
    end
  end
  # rubocop:enable Metrics/MethodLength, Metrics/CyclomaticComplexity, Metrics/AbcSize

  # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
  unless defined?(in_groups_of)
    def in_groups_of(number, fill_with = nil)
      if number.to_i <= 0
        raise ArgumentError,
              "Group length must be a positive integer, was #{number.inspect}"
      end

      if fill_with == false
        collection = self
      else
        padding = (number - length % number) % number
        collection = dup.concat(::Array.new(padding, fill_with))
      end

      sliced_collection = collection.each_slice(number)
      block_given? ? sliced_collection { |val| yield(val) } : sliced_collection.to_a
    end
  end
  # rubocop:enable Metrics/MethodLength, Metrics/AbcSize

  unless defined?(indexes)
    def indexes(value)
      results = []
      each_with_index { |val, i| results << i if value == val }
      results
    end
  end

  unless defined?(merge)
    def merge(*values)
      values.each { |val| concat(val) }
      self
    end
  end

  unless defined?(nillify)
    def nillify
      map { |val| !val.nil? && (val.try(:blank?) || val.try(:to_s).blank?) ? nil : val }
    end
  end

  unless defined?(nillify!)
    def nillify!
      replace(nillify)
    end
  end

  unless defined?(position)
    def position(value)
      idx = index(value)
      return if idx.nil?

      idx + 1
    end
  end

  unless defined?(positions)
    def positions(value)
      indexes(value).map { |val| val + 1 }
    end
  end

  unless defined?(probability)
    def probability
      hash = ::Hash.new(0.0)
      differ = 0.0

      each do |val|
        hash[val] += 1.0
        differ += 1.0
      end

      hash.each_key { |val| hash[val] /= differ }
      hash
    end
  end

  unless defined?(promote)
    def promote(value)
      sort_by { |val| val == value ? -1 : 0 }
    end
  end

  unless defined?(promote!)
    def promote!(value)
      replace(promote(value))
    end
  end

  unless defined?(reject_values)
    def reject_values(*args)
      reject { |val| args.include?(val) }
    end
  end

  unless defined?(rposition)
    def rposition(value)
      idx = rindex(value)
      return if idx.nil?

      idx + 1
    end
  end

  unless defined?(sample!)
    def sample!
      delete_at(::Random.rand(length - 1))
    end
  end

  # rubocop:disable Metrics/AbcSize, Metrics/BlockNesting, Metrics/MethodLength
  unless defined?(split)
    def split(number = nil)
      if block_given?
        each_with_object([[]]) do |element, results|
          yield(element) ? (results << []) : (results.last << element)
        end
      else
        results = [[]]
        arr = dup

        until arr.empty?
          if (idx = arr.index(number))
            results.last.concat(arr.shift(idx))
            arr.shift
            results << []
          else
            results.last.concat(arr.shift(arr.length))
          end
        end

        results
      end
    end
  end
  # rubocop:enable Metrics/AbcSize, Metrics/BlockNesting, Metrics/MethodLength

  unless defined?(strip)
    def strip
      reject(&:blank?)
    end
  end

  unless defined?(strip!)
    def strip!
      replace(strip)
    end
  end

  unless defined?(swap)
    def swap(from, to)
      self[from], self[to] = self[to], self[from]
      self
    end
  end

  unless defined?(to)
    def to(position)
      position >= 0 ? first(position + 1) : self[0..position]
    end
  end

  # rubocop:disable Metrics/MethodLength
  unless defined?(to_sentence)
    def to_sentence(options = {})
      options = {
        words_connector: ', ',
        two_words_connector: ' and ',
        last_word_connector: ', and '
      }.merge!(options)

      case length
      when 0
        ''
      when 1
        self[0].to_s.dup
      when 2
        "#{self[0]}#{options[:two_words_connector]}#{self[1]}"
      else
        "#{self[0...-1].join(options[:words_connector])}#{options[:last_word_connector]}#{self[-1]}"
      end
    end
  end
  # rubocop:enable Metrics/MethodLength

end