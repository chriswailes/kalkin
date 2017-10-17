def fib(n : Integer) -> Integer
	if n <= 1
		1
	else
		fib(n - 1) + fib(n - 2)
	end
end

def main -> void
	fib(12)
end
