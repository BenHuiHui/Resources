gcc runtime.c $1 -o a.exe

for (( i = 1; i <= 10; i++))
do
	./a.exe
done
