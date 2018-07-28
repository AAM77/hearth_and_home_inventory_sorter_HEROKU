Item.all.clear
Folder.all.clear
Category.all.clear
User.all.clear



apples = User.create_user(username: "Apples", email: "Apples@test.com", password: "orange")
joe = User.create_user(username: "Joe", email: "joe@test.com", password: "123abcjoe")
john = User.create_user(username: "John", email: "john@test.com", password: "123abcjohn")
karim = User.create_user(username: "Karim", email: "karim@test.com", password: "123abckarim")
sarah = User.create_user(username: "Sarah", email: "sarah@test.com", password: "123abcsarah")
karen = User.create_user(username: "Karen", email: "karen@test.com", password: "123abckaren")
annie = User.create_user(username: "Annie", email: "annie@test.com", password: "123abcannie")
huang = User.create_user(username: "Huang", email: "huangtest.com", password: "123abchuang")
motunui = User.create_user(username: "Motunui", email: "motunui@test.com", password: "123abcmotunui")


joe.create_folder("Dorm")
john.create_folder("Dining Room")
karim.create_folder("Bedroom")
sarah.create_folder("Guest Room")
karen.create_folder("Misc")
annie.create_folder("Bedroom")
huang.create_folder("Gym")
motunui.create_folder("My Island")
apples.create_folder("Friends")




User.all.each {|user| user.folders << Folder.create(name: "Triple A")}
User.all.each {|user| user.folders << Folder.create(name: "J Room")}

User.all.each {|user| user.items << Item.create(name: "Pen", description: "123abc desc", cost: 22) }
User.all.each {|user| user.items << Item.create(name: "Ball",  description:"123abc desc plus",cost:  122)}
User.all.each {|user| user.items << Item.create(name: "Laptop", description: "123abc desc a lot",cost:  225)}
User.all.each {|user| user.items << Item.create(name: "TV", description: "123abc desc wow",cost:  22)}
User.all.each {|user| user.items << Item.create(name: "Apples",  description:"123abc desc delicious",cost:  232)}
User.all.each {|user| user.items << Item.create(name: "Bookshelf", description: "123abc desc amazing",cost:  252)}
User.all.each {|user| user.items << Item.create(name: "Essential Oil Diffuser", description: "123abc desc aromatic",cost:  522)}
User.all.each {|user| user.items << Item.create(name: "Air Purifier", description: "123abc desc clean!",cost:  722)}

Folder.all.each do |folder|
  Item.all.each do |item|
    if !folder.nil?
      folder.items << item if folder.user_id == item.user_id
    end
  end
end

Category.all.each do |category|
  Item.all.each do |item|
    if !category.nil?
      category.items << item if category.user_id == item.user_id
    end
  end
end
