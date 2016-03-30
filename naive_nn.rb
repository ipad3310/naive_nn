require 'distribution'
require 'json'
require 'narray'
require 'zip'

TEST_FILE = "test.json"
VALIDATION_FILE = "validation.json"
TRAINING_FILE = "train.json"
class NeuralNetwork
	attr_accessor :sizes, :biases, :weights

	def initialize(sizes)
		@sizes = sizes
		@biases = sizes[1..-1].map{|neus| neus.times.map {Distribution::Normal.rng(0).call}}
		@weights = sizes.each_cons(2).map{|i| Array.new(i[1],i[0].times.map {Distribution::Normal.rng(0).call})}
	end

	def vote(input)
		current = input
		@weights.length.times do |i|
			current = @weights[i].zip(@biases[i]).map{|w_b| sigmoid(dot(w_b[0],current)+w_b[1])}
		end
		current
	end

	def output(input)
		vote(input).each_with_index.max[1]
	end

	def learn(training_data, epochs, mini_batch_size, rate, test_data=nil)
	end

	def learn_with(mini_batch, rate)
	end

	def back_prop(input, answer)

	end

end

def load_json(filename)
	JSON.parse(Zip::File.open("#{filename}.zip").read(filename))
end

def _evaluate(data_row, net)
	data_row["answer"].each_with_index.max[1] == net.output(data_row["feature"]) ? 1 : 0
end

def evaluate(data, net)
	results = data.map{|data_row| _evaluate(data_row, net)}
	results.inject(:+)/results.length.to_f
end

def dot(v0,v1)
	hadamard_product(v0,v1).inject(:+)
end

def hadamard_product(v0,v1)
	v0.zip(v1).map{|v| v[0]*v[1]}
end

def v_add(v0,v1)
	v0.zip(v1).map{|v| v[0]+v[1]}
end

def sigmoid(z)
	1.0/(1.0+Math::exp(-z))
end

def sigmoid_prime(z)
	sigmoid(z)*(1-sigmoid(z))
end
