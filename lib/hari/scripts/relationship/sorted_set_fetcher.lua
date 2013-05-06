function _h.fetch_relations_ids(start_node_id, relation, direction, start, stop, h)
  local key = 'hari:'..start_node_id..':r:'..relation..':'..direction
  return redis.call('zrevrange', key, start, stop)
end

function _h.fetch_nodes_ids(start_node_id, relation, direction, start, stop, h)
  local rels_ids = h.fetch_relations_ids(start_node_id, relation, direction, start, stop)

  return h.map(rels_ids, function(r) return h.split(r, ':')[2] end)
end
