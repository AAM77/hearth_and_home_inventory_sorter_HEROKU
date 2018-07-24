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
USERS.each {|user| user.create_folder("Triple A") if user.username.downcase.include?("a")}
USERS.each {|user| user.create_folder("J Room") if user.username.downcase.include?("j")}
USERS.each {|user| user.create_item("Pen")}
USERS.each {|user| user.create_item("Ball")}
USERS.each {|user| user.create_item("Laptop")}
USERS.each {|user| user.create_item("TV")}
USERS.each {|user| user.create_item("Apples")}
USERS.each {|user| user.create_item("Bookshelf")}
USERS.each {|user| user.create_item("Essential Oil Diffuser")}
USERS.each {|user| user.create_item("Air Purifier")}
