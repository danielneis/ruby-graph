require 'powerset'

describe Array do

  it "should calculate its powerset" do
    set = [1, 2, 3]
    powerset = [[],[1], [2], [3], [1,2], [1,3], [2,3], [1,2,3]]

    (powerset - set.powerset).empty?.should be_true
    (set.powerset - powerset).empty?.should be_true
  end
end
