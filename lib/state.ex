defrecord Cage.State, stack: nil, dict: [] do
  def put(k, v, rec) do
    dict(Keyword.put(dict(rec), k, v), rec)
  end

  def get(k, rec) do
    dict(rec)[k]
  end
end