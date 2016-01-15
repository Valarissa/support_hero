class NullHero
  def name
    "Nobody"
  end

  def undoable_days
    []
  end

  def undoable(*); end

  def days
    Day.unscoped.where(hero_id: nil)
  end
end
