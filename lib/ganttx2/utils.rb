# frozen_string_literal: true

module Ganttx2
  class Utils
    class << self
      def hash_merge(src_hs1, src_hs2)
        hs1 = src_hs1.nil? ? {} : src_hs1
        hs2 = src_hs2.nil? ? {} : src_hs2
        # hs1, hs2 = [src_hs1, src_hs2].map{ |x| x.nil? ? {} : x }
        # ks = [hs1.keys + hs2.keys].flatten(1).sort.uniq
        ks = [hs1.keys + hs2.keys].flatten(1).uniq
        ks.each_with_object({}) do |k, memo|
          ary = []
          ary += hs1[k] if hs1[k]
          ary += hs2[k] if hs2[k]
          # memo[k] = ary.sort.uniq
          memo[k] = ary.uniq
        end
      end
    end
  end
end
