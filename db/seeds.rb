Item.all.clear
Folder.all.clear
Category.all.clear
User.all.clear


USERS = []

USERS << apples = User.create(username: "Apples", email: "Apples@test.com", password: "orange")
USERS << joe = User.create(username: "Joe", email: "joe@test.com", password: "123abcjoe")
USERS << john = User.create(username: "John", email: "john@test.com", password: "123abcjohn")
USERS << karim = User.create(username: "Karim", email: "karim@test.com", password: "123abckarim")
USERS << sarah = User.create(username: "Sarah", email: "sarah@test.com", password: "123abcsarah")
USERS << karen = User.create(username: "Karen", email: "karen@test.com", password: "123abckaren")
USERS << annie = User.create(username: "Annie", email: "annie@test.com", password: "123abcannie")
USERS << huang = User.create(username: "Huang", email: "huangtest.com", password: "123abchuang")
USERS << motunui = User.create(username: "Motunui", email: "motunui@test.com", password: "123abcmotunui")

joe.create_folder("Dorm")
john.create_folder("Dining Room")
karim.create_folder("Bedroom")
sarah.create_folder("Guest Room")
karen.create_folder("Misc")
annie.create_folder("Bedroom")
huang.create_folder("Gym")
motunui.create_folder("My Island")

USERS.each {|user| user.initial_folders}
USERS.each {|user| user.initial_categories}
USERS.each {|user| user.create_folder("Triple A") if user.username.downcase.include?("a")}
USERS.each {|user| user.create_folder("J Room") if user.username.downcase.include?("j")}

USERS.each {|user| user.items << Item.create(name: "Pen", description: "123abc desc", cost: 22)}
USERS.each {|user| user.items << Item.create(name: "Ball",  description:"123abc desc plus",cost:  122)}
USERS.each {|user| user.items << Item.create(name: "Laptop", description: "123abc desc a lot",cost:  225)}
USERS.each {|user| user.items << Item.create(name: "TV", description: "123abc desc wow",cost:  22)}
USERS.each {|user| user.items << Item.create(name: "Apples",  description:"123abc desc delicious",cost:  232)}
USERS.each {|user| user.items << Item.create(name: "Bookshelf", description: "123abc desc amazing",cost:  252)}
USERS.each {|user| user.items << Item.create(name: "Essential Oil Diffuser", description: "123abc desc aromatic",cost:  522)}
USERS.each {|user| user.items << Item.create(name: "Air Purifier", description: "123abc desc clean!",cost:  722)}


Folder.all.each do |folder|
  Item.all.each do |item|
    if folder.empty?
      folder << item
    end
  end
end

Category.all.each do |category|
  Item.all.each do |item|
    if category.empty?
      category << item
    end
  end
end
