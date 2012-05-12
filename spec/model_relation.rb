describe "Relation using Bag" do  
  class Player < NanoStore::Model
    bag :games
  end
  
  class Game < NanoStore::Model
    attribute :name
  end

  # TODO implement this
  it "can have bag in object " do
    player = Player.new
    player.games = Bag.bag

    gow = Game.new(:name => "Gears of War")
    halo = Game.new(:name => "Halo")
    player.games << gow
    player.games << halo
    player.save

    player.games.count.should == 2
  end
end