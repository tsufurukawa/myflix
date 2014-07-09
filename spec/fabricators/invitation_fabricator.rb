Fabricator(:invitation) do
  inviter_id { 1 }
  recipient_name { Faker::Name.name }
  recipient_email { Faker::Internet.email }
  message { Faker::Lorem.paragraph(3) }
end