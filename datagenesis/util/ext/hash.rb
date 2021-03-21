# frozen_string_literal: true

class Hash
  def modify_or_initialize(key, default)
    raise 'No block given!' unless block_given?

    maybe_val = fetch(key, default)
    yield maybe_val
    self[key] = maybe_val
  end
end
