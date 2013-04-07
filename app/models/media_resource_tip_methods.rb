module MediaResourceTipMethods
  def created_tips
    MediaResourceCreatedTip.build(self)
  end

end