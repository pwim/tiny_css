module TinyCss
  class OrderedHash
    include Enumerable

    attr_accessor :keys

    def initialize
      self.keys = []
      @hash = Hash.new { |h, k|
        self.keys << k.to_s
        h[k] = OrderedHash.new
      }
    end

    def [](key)
      @hash[key.to_s]
    end

    def []=(key, value)
      key = key.to_s
      @hash[key] = value
      self.keys << key unless self.keys.include?(key)
    end

    def delete(key, &block)
      key = key.to_s
      self.keys.delete key
      @hash.delete key, &block
    end

    def dup
      dup = super
      dup.keys = self.keys.dup
      dup
    end

    def each(&block)
      self.keys.each { |k| yield [k, self[k]] }
      self
    end

    def inspect
      ary = []
      each { |k, v| ary << "#{ k.inspect }=>#{ v.inspect }" }
      "{#{ ary.join(', ') }}"
    end

    def to_s
      map { |k, v| "#{ k }:#{ v }" }.join ';'
    end

    def empty?
      @hash.empty?
    end

    def key?(key)
      keys.include?(key)
    end

    def split(*keys_to_split)
      h = self.class.new
      keys.find_all {|k| keys_to_split.include?(k) }.each do |k|
        h[k] = delete(k)
      end
      h
    end
  end
end
