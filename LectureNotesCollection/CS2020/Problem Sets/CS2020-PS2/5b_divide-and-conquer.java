// assume nil is a special value, can be casted to class Node

class Node{
	int order;	// the order of the element
	int frequency;	// the times of appearance of the element

	Node(int order, int frequency){
		this.order=order; this.frequency = frequency;
	}
}

Node count-votes(int start, int end){	// return value: node
	if(start +1 >= end) return votes[start]
	middle = (start + end) /2;
	left = count-votes(start,middle);// store the largest frequency in the left part, and the order
	right = count-votes(middle+1, end);

	if(left!=nil){
		if(right!=nil)	
			if(left.order==right.order)
				return new Node(left.order, left.frequency+right.frequency);
		left.frequency += count-frequency(middle+1,right,left.order);
		if(left.frequency>(end-start+1)/2)	return left;)
	}

	if(right!=nil){
		right.frequency += count-frequency(start,middle,right.order);
		if(right.frequency> (end-start+1)/2)	return right;
	}
	
	return nil;	// no element's frequency exceed half
}

// to count the frequency of the value "order" from start to end in the array votes.
int count-frequency(int start,int end,int order){
	int i,count=0;
	for(i=start;i<=end;i++)	if(votes[i]==order)	count++;
	return count;
}
