class DecisionTree < ActiveRecord::Base

attributes = ['Genre'] # tie "interest" to 0 for neutral, 1 for like, and -1 to dislike
training = [
  ['Novel', 1],
  ['Contemporary', 1],
  ['< 18', 'High School', 'Low', 'Married', 1]
  # ... more training examples
]

# Instantiate the tree, and train it based on the data (set default to '1')
dec_tree = DecisionTree::ID3Tree.new(attributes, training, 1, :discrete)
dec_tree.train

test = ['< 18', 'High School', 'Low', 'Single', 0]

decision = dec_tree.predict(test)
puts "Predicted: #{decision} ... True decision: #{test.last}";

# Graph the tree, save to 'discrete.png'
dec_tree.graph("discrete")
end