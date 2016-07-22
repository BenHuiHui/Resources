from collections import deque

def task1(x,sem,completed):
    #enter critical session
    sem[0] -= 1
    if sem[0] < 0:
        sem[1] = True
    
    yield
    reg = x[0]  # increment a shared variable
    yield       # simulate the non-atomicity of load and store operations
    reg = reg+1 # that would be observed in realistic hardware
    yield
    x[0] = reg
    yield

    sem[0] += 1
    if sem[0] <= 0:
        sem[2] = True
        
    completed[0] = True
    yield

def task2(x,sem,completed):
    #enter critical session
    sem[0] -= 1
    if sem[0] < 0:
        sem[1] = True
        
    yield
    reg = x[0]
    yield
    reg = reg+1
    yield
    x[0] = reg
    yield

    sem[0] += 1
    if sem[0] <= 0:
        sem[2] = True
        
    completed[0] = True
    yield

def scheduler():
    x = [0]

    
    # semaphore structure: num, blockThis(bool), releaseNew
    sem = [1,False,False]
    # to mark if a task hsa been completed
    completed = [False]
    
    tasks = [task1(x,sem,completed),task2(x,sem,completed)]
    totalNumTasks = len(tasks)

    # list of blocked tasks
    blockedTaskList = deque([])

    # status of tasks -- blocked or not
    blocked = [False for i in range(totalNumTasks)]
    taskComplete = [False for i in range(totalNumTasks)]

    # prepare for loop
    i = 0;
    (task1Steps,task2Steps) = (5,5)
    totalNumSteps = task1Steps + task2Steps


    while i < totalNumSteps:
        i += 1
        taskNum = i%2
        
        if blocked[taskNum] or taskComplete[taskNum]:
            totalNumSteps += 1
            continue
        
        sem[1] = False
        sem[2] = False
        completed[0] = False
        
        tasks[taskNum].next()
        if sem[1]:
            blocked[taskNum] = True
            blockedTaskList.append(taskNum)
        elif sem[2]: # need to release a blocked task
            taskToRelease = blockedTaskList.popleft()
            blocked[taskToRelease] = False

        if completed[0]:
            taskComplete[taskNum] = True
    
    
    print "x =",x[0]

