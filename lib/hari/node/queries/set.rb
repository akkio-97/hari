module Hari
  class Node < Entity
    module Queries
      class Set

        attr_reader :node, :set_name

        def initialize(node)
          @node = node
        end

        def key
          "#{Hari.node_key(node)}:#{set_name}"
        end

        def set(name)
          @set_name = name
          self
        end

        def set!(name)
          @set_name = name
          members
        end

        def members
          Hari.redis.smembers key
        end

        def rand(count = 1)
          Hari.redis.srandmember key, count
        end

        def count
          Hari.redis.scard key
        end

        alias :size :count
        alias :length :count

        def include?(member)
          Hari.redis.sismember key, member
        end

        def add(*members)
          Hari.redis.sadd key, members
        end

        def <<(member)
          add member
        end

        def delete(*members)
          Hari.redis.srem key, members
        end

        def pop
          Hari.redis.spop key
        end

        def intersect(*set_queries)
          Hari.redis.sinter key, set_query_keys(set_queries)
        end

        def &(other_set_query)
          intersect other_set_query
        end

        def diff(*set_queries)
          Hari.redis.sdiff key, set_query_keys(set_queries)
        end

        def -(other_set_query)
          diff other_set_query
        end

        private

        def set_query_keys(set_queries)
          keys = set_queries.map do |query|
            ensure_set_query! query
            query.key
          end

          fail 'no query keys' if keys.empty?

          keys
        end

        def ensure_set_query!(query)
          unless query.kind_of?(Hari::Node::Queries::Set)
            fail 'not a set query'
          end
        end

      end
    end
  end
end