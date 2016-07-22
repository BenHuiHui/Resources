int findNextTask()
{
	int i;
	// Apply scheduling algorithm to find next task to run, and returns the index number of that task.
	// Note that OS_NUM_TASKS in kernel.h is the MAXIMUM number of tasks that can be created, not the actual number
	// created. So OS_NUM_TASKS can be 10 although in actual fact only 4 tasks were created. You should pick only amongst
	// these 4 tasks.
	for(i = currentTask + 1; i< task_counter; i++){
		if(taskTable[i].runflag == TASK_BLOCKED)	continue;
		else	return i;
	}
	
	for(i=0; i< currentTask; i++){
		if(taskTable[i].runflag == TASK_BLOCKED)	continue;
		else	return i;
	}
	
	return -1;	// unsuccessful
}


