class Array

  def powerset
    self.inject([[]]) { |acc, you|
      ret = []
      acc.each { |i|
        ret << i
        ret << i + [you]
      }
      ret
    }
  end
end
