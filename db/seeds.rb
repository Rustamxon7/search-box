titles = [
  "The Great Gatsby",
  "Why is the sky blue?",
  "What is the meaning of life?",
  "How do I make a peanut butter and jelly sandwich?",
  "Next.js vs. Gatsby.js: What are the differences?",
  "When is the next full moon?",
  "Who is the president of the United States?",
  "Where is the nearest grocery store?",
  "What is the best way to learn to code?",
]

5.times do
  User.create(
    email: Faker::Internet.email,
    password: "password",
    password_confirmation: "password",
  )
end

titles.each do |title|
  Article.create(
    title: title,
    content: Faker::Lorem.paragraph(sentence_count: 10),
    user_id: User.all.sample.id,
  )
  puts "💾 #{title} saved."
end

puts
puts "🌱🌱🌱 Data Seeded. 🌱🌱🌱"
puts