from revChatGPT.V1 import Chatbot
from binarytree import Node

# function to get the result of a chatgpt prompt (keep in mind this depends on previous prompts/setup)
def getChatPrompt(chatbot, prompt):
    prev_text = ""
    for data in chatbot.ask(
        prompt
    ):
        # message = data["message"][len(prev_text) :]
        prev_text = data["message"] # keeps updating the message as the bot returns text (maybe not optimal)
    return prev_text

def askQuestion(question):
    return question

def showHint(hint):
    return hint

def showAnswerIndex(question):
    return question.correct

def showSnippet(snippet):
    return snippet
    
# class with article summarization functionality
class ArticleSummarizerBot:
    def __init__ (self, initFileName):
        credentials = open("credentials.txt", "r")
        
        self.chatbot = Chatbot(config={
    "email": credentials.readline(),
    "password": credentials.readline()
})
        # no setup message
        if initFileName is None:
            return
        
        # setup file to config the bot
        myFile = open(initFileName, "r+")
        initialPrompt = myFile.read()
        result = getChatPrompt(self.chatbot, initialPrompt)
        
    ## Functions with article_summarization_setup.txt setup file  
        
    # summarizes article based on specificity level between 1 and 5 (5 gives the original article)
    def summarize(self, article, spec):
        prompt = "Text: "
        prompt += article
        prompt += ("\n Specificity level: " + str(spec))
        return getChatPrompt(self.chatbot, prompt)
    
    # makes all summaries with specificity levels between 1 and 4 and returns a list of them
    def makeAllSummaries(self, article):
        specRange = range(4)
        summaries = [self.summarize(article, i+1) for i in specRange]
        return summaries
    
    ## Functions with topic_setup.txt setup file
    
    # gets the topic of passages
    def getTopicOfSummaries(self, articles):
        prompt = "What is the topic of the following passages: \n"
        for a in articles:
            prompt += (a + '\n')
        topic = getChatPrompt(self.chatbot, prompt)
        if topic[:7] == 'topic: ':
            topic = topic[7:]
        if topic[-1] is '.':
            topic = topic[:-1]
        return topic
    
class Question:
    def __init__(self, question, answers, correct):
        self.question = question # string with question itself
        self.answers = answers # list of strings with answers
        self.correct = correct # int with index of correct answeer
        
    def setCorrectIndex(self, correctIndex):
        self.correctIndex = correctIndex
    
    def correctlyAnswered(self, answerIndex):
        if (self.correctIndex == answerIndex):
            return True
        return False  
    
    def setQuestion(self, question):
        self.question = question
        
    def setAnswers(self, answers):
        self.answers = answers
        
    def setCorrect(self, correct):
        self.correct = correct
    
    
class Lesson:
    def __init__(self, title, topics = [], subtitle = ""):
        self.title = title # lesson title
        self.topics = topics # list of Topics
        self.subtitle = subtitle # subtitle/general topic of lesson  
        
    def runLesson(self):
        # loop through each topic
        for topic in self.topics():
            topic.runTopic()
            
        
    def addTopic(self, topic):
        self.topics.append(topic)
        
    def setSubtitle(self, subtitle):
        self.subtitle = subtitle
    
    def resetTitle(self, title):
        self.title = title
        
    def setCorrect(self, correct):
        self.correct = correct
        
    def editTopic(self, index, newTopic = None):
        if newTopic is None:
            self.topics.remove(index)
        else:
            self.topics[index] = newTopic
            
class RepeatingHint:
    # list of hints and current index
    def __init__(self, hints = []):
        self.repNum = 0
        self.hints = hints
        
    def addHint(self, hint):
        self.hints.append(hint)
        
    def editHint(self, index, newHint = None):
        if newHint is None:
            self.hints.remove(index)
        else:
            self.hints[index] = newHint
    

class Topic:
    # this init method will take a very long time
    #TODO: not sure how much I should have here
    def __init__(self, article, questions, firstObj):
        self.questions = [questions] # each question in topic (might be needed later )
        self.layout = Node(firstObj) # start of layout of sublesson
        
        # get summaries of article
        articleSumBot = ArticleSummarizerBot("article_summarization_setup.txt")
        self.summaries = articleSumBot.makeAllSummaries(article)
        
        # get topic of summaries
        topicBot = ArticleSummarizerBot("topic_setup.txt")
        self.topic = topicBot.getTopicOfSummaries(self.summaries)
        
    # add object to layout
    def setLayout(self, obj, directionLeft = None, correct = True):
        self.layout = Node(self.layout.value) # clears pointers
        # this will only run if we are at the root
        if directionLeft is None:
            self.leftLeaf = self.layout
            self.rightLeaf = self.layout
            currNode = self.layout
        
        # set current node based on which leaf we are looking at
        if directionLeft:
            currNode = self.leftLeaf
        else:
            currNode = self.rightLeaf
         
        # add object to left side if correct (or if default)
        if correct:
            currNode.left = Node(obj)
            self.leftLeaf = currNode.left 
          
        # add object to right side if incorrect  
        else:
            currNode.right = Node(obj)
            self.rightLeaf = currNode.right  
            
    def runTopic(self):
        # root of layout
        currNode = self.layout
        while True:
            # get value from node               
            obj = currNode.value
            if type(obj) is Question:
                # ask the question
                askQuestion(obj) # would also display answers
                self.correct = False
                #TODO: add way to get whether user answered correctly
                if self.correct == True:
                    currNode = currNode.left # go to left if correct
                else:
                    if type(currNode.right.value) is RepeatingHint: # if at last level of depth
                        # print hint
                        showHint(obj) # this would be taken care of on the frontend
                        # go to next hint
                        # if (obj.repNum < len(obj.hints) - 1):
                        #     obj.repNum += 1
                        # else:
                        #     showAnswer(obj) # if there are no more hints 
                        #     break
                    # go to right if wrong
                    currNode = currNode.right
            # display snippet if string
            elif type(obj) is str:
                showSnippet(obj)
                currNode = currNode.left
            else: # obj would be null
                showSnippet("done")
                break
           
    def addQuestion(self, question):
        self.questions.append(question)
        
    def editQuestion(self, index, newQuestion = None):
        if newQuestion is None:
            self.questions.remove(index)
        else:
            self.questions[index] = newQuestion