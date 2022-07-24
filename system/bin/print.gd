extends Command

func _init():
	keyword = "print"

func execute(args):
	var output = ""
	for i in args:
		output += " " + str(i)
	print("printing : " + output)
