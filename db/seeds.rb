5.times {
  User.create(
    username: Faker::Internet.username,
    email: Faker::Internet.email,
    password: "password"
  )
}

12.times {
  Article.create(
    title: Faker::Lorem.sentence(word_count: 3),
    content: Faker::Lorem.paragraph(sentence_count: 3),
    user_id: rand(1..5)
  )
}

puts
puts "🌱🌱🌱 Data Seeded. 🌱🌱🌱"
puts