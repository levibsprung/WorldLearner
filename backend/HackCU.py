from revChatGPT.V1 import Chatbot
from anytree import Node
import os

os.chdir('./backend')




# function to get the result of a chatgpt prompt (keep in mind this depends on previous prompts/setup)
def getChatPrompt(chatbot, prompt):
    prompt = prompt.replace('\n', ' ')
    prev_text = ""
    for data in chatbot.ask(
        prompt,
    ):
        # message = data["message"][len(prev_text) :]
        prev_text = data["message"] # keeps updating the message as the bot returns text (maybe not optimal)
    return prev_text

def askQuestion(question):
    for i, answer in enumerate(question.answers):
        print(chr(i+65) + ". " + answer)

def showHint(hint):
    return hint

def showAnswerIndex(question):
    return question.correct

def showSnippet(snippet):
    return snippet

def fileNameToString(filename):
    f = open(filename, "r", encoding="utf-8")
    return f.read()
    
    
    
# tree class with new functionality
class NewNode(Node):
    def __init__ (self, obj, left = None, right = None):
        Node.__init__(self, obj)
        self.left = left
        self.right = right
        
    def _build_tree_string(self, curr_index, include_index = False, delimiter = "-"):
        if self is None:
            return [], 0, 0, 0

        line1 = []
        line2 = []
        if include_index:
            node_repr = "{}{}{}".format(curr_index, delimiter, self.name)
        else:
            node_repr = str(self.name)

        new_root_width = gap_size = len(node_repr)

        # Get the left and right sub-boxes, their widths, and root repr positions
        l_box, l_box_width, l_root_start, l_root_end = self._build_tree_string(
            self.left, 2 * curr_index + 1, include_index, delimiter
        )
        r_box, r_box_width, r_root_start, r_root_end = self._build_tree_string(
            self.right, 2 * curr_index + 2, include_index, delimiter
        )

        # Draw the branch connecting the current root node to the left sub-box
        # Pad the line with whitespaces where necessary
        if l_box_width > 0:
            l_root = (l_root_start + l_root_end) // 2 + 1
            line1.append(" " * (l_root + 1))
            line1.append("_" * (l_box_width - l_root))
            line2.append(" " * l_root + "/")
            line2.append(" " * (l_box_width - l_root))
            new_root_start = l_box_width + 1
            gap_size += 1
        else:
            new_root_start = 0

        # Draw the representation of the current root node
        line1.append(node_repr)
        line2.append(" " * new_root_width)

        # Draw the branch connecting the current root node to the right sub-box
        # Pad the line with whitespaces where necessary
        if r_box_width > 0:
            r_root = (r_root_start + r_root_end) // 2
            line1.append("_" * r_root)
            line1.append(" " * (r_box_width - r_root + 1))
            line2.append(" " * r_root + "\\")
            line2.append(" " * (r_box_width - r_root))
            gap_size += 1
        new_root_end = new_root_start + new_root_width - 1

        # Combine the left and right sub-boxes with the branches drawn above
        gap = " " * gap_size
        new_box = ["".join(line1), "".join(line2)]
        for i in range(max(len(l_box), len(r_box))):
            l_line = l_box[i] if i < len(l_box) else " " * l_box_width
            r_line = r_box[i] if i < len(r_box) else " " * r_box_width
            new_box.append(l_line + gap + r_line)

        # Return the new box, its width and its root repr positions
        return new_box, len(new_box[0]), new_root_start, new_root_end
        
    def __str__(self):
        lines = self._build_tree_string(self, 0, False, "-")[0]
        return "\n" + "\n".join((line.rstrip() for line in lines))

# class with article summarization functionality
class ArticleSummarizerBot:
    def __init__ (self, initFileName):
        credentials = open("credentials.txt", "r", encoding="utf-8")
        email = credentials.readline()
        email = email[:-1]
        self.chatbot = Chatbot(config={
    "email": email,
    "password": credentials.readline()
})
        # no setup message
        if initFileName is None:
            return
        
        # setup file to config the bot
        myFile = open(initFileName, "r+", encoding="utf-8")
        initialPrompt = myFile.read()
        # print(initialPrompt)
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
    # def getTopicOfSummaries(self, articles):
    #     prompt = "What is the topic of the following passages: \n"
    #     for a in articles:
    #         prompt += (a + '\n')
    #     topic = getChatPrompt(self.chatbot, prompt)
    #     if topic[:7] == 'topic: ':
    #         topic = topic[7:]
    #     if topic[-1] == '.':
    #         topic = topic[:-1]
    #     return topic
    
class Question:
    def __init__(self, question, answers, correct):
        self.question = question # string with question itself
        self.answers = answers # list of strings with answers
        self.correct = correct # int with index of correct answeer
        
    def setCorrect(self, correctIndex):
        self.correct = correctIndex
    
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
        
    def __str__(self):
        return "Question: " + self.question
    
    
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
    
    def __str__(self):
        return "Repeating hint"
    
    def showHint(self):
        if self.repNum >= len(self.hints):
            return False
        print(self.hints[self.repNum])
        self.repNum += 1
        return True
    

class Topic:
    # this init method will take a very long time
    #TODO: not sure how much I should have here
    def __init__(self, article, questions):
        self.questions = questions # each question in topic (might be needed later )
        
        # get summaries of article
        self.summaries = ["summary1", "summary2", "summary3", "summary4"]
            
        outputFileName = "summaries_of_" + article
        outputFile = open(outputFileName, 'w+', encoding='utf-8')
        for i, s in enumerate(self.summaries):
            outputFile.write("Summary " + str(i+1) + ":\n")
            outputFile.write(s)
            outputFile.write('\n')
        
        outputFile.close()
        
        
    def getOutput(self, outputFileName):
        outputFile = open(outputFileName, "w+", encoding='utf-8')
        
        # outputFile.write("Topic of summaries: " + self.topic)
        outputFile.write('\n')
        
        for i, s in enumerate(self.summaries):
            outputFile.write("Summary " + str(i+1) + ":\n")
            outputFile.write(s)
            outputFile.write('\n')
        
        outputFile.write("\nQuestions:\n") 
        for i, q in enumerate(self.questions):
            outputFile.write(str(i+1) + ". " + q.question + "\n")   
        
        outputFile.close()
        
    def setRoot(self, firstObj):
        self.layout = NewNode(firstObj) # start of layout of sublesson
        self.leftLeaf = self.layout
        self.rightLeaf = self.layout
        self.currNode = self.layout
        
    # add object to layout
    def setLayout(self, obj, directionLeft = None, correct = True):       
        # set current node based on which leaf we are looking at
        if directionLeft:
            self.currNode = self.leftLeaf
        elif not directionLeft:
            self.currNode = self.rightLeaf
         
        # add object to left side if correct (or if default)
        if correct:
            self.currNode.left = NewNode(obj)
            self.leftLeaf = self.currNode.left 
          
        # add object to right side if incorrect  
        else:
            self.currNode.right = NewNode(obj)
            self.rightLeaf = self.currNode.right  
            
    def runTopic(self):
        # root of layout
        currNode = self.layout
        while True:
            # get value from node 
            if currNode is None:
                print("(going to next topic)")
                break
            obj = currNode.name
            if type(obj) is Question:
                print(obj.question)
                askQuestion(obj) # would also display answers
                self.correct = False
                index = ord(input()[0])-65
                if index == obj.correct:
                    self.correct = True
                if self.correct:
                    currNode = currNode.left # go to left if correct
                else:
                    if type(currNode.right.name) is RepeatingHint: # if at last level of depth
                        # print hint
                        if (not currNode.right.name.showHint()):
                            print("The correct answer is " + obj.answers[obj.correct])
                            break
                        # this would be taken care of on the frontend
                        # go to next hint
                    # go to right if wrong
                    else:
                        currNode = currNode.right
            # display snippet if string
            elif type(obj) is str:
                if obj.__contains__("summary"):
                    print("showing summary")
                else:
                    print(obj)
                currNode = currNode.left
            else: # obj would be null
                print(type(obj))
                break
           
    def addQuestion(self, question):
        self.questions.append(question)
        
    def editQuestion(self, index, newQuestion = None):
        if newQuestion is None:
            self.questions.remove(index)
        else:
            self.questions[index] = newQuestion
            

question1 = Question("Which of the following is NOT a reason why we should address people using the correct pronouns?", ["To promote inclusion", "To avoid social backlash", "To demonstrate respect towards people", "To show people that you value their identities"], 1)
question2 = Question("What is the best thing to do if you don't know someone's pronouns?", ["Avoid using any pronouns to address them", "Ask them what their pronouns are", "Make a guess", "Leave the conversation",], 2)

pronouns = Topic("pronouns_what_and_why.txt", [question1, question2])

# pronouns.setRoot(pronouns.summaries[2])
# # pronouns.setLayout(question1)
# # pronouns.setLayout(pronouns.summaries[3], False)
# # pronouns.setLayout(question2, False)
hint = RepeatingHint(["Remember, the goal of using correct pronouns is to make people feel respected and included.", "When you don't know someone's pronouns, you should ask them what they are."])
# # pronouns.setLayout(hint, False, False) 

question1 = Question("What does it mean to be transgender?", ["People who identify with the gender they were assigned at birth", "People who are not a male or a female", "People who have undergone gender-affirming surgery", "People who identify as a different gender from the one assigned at birth"], 3)
question2 = Question("Which of the following is a sexuality that is NOT encompassed by the term 'transgender'?", ["Cisgender", "Genderfluid", "Non-binary", "Agender",], 0)

aboutTrans = Topic("what_does_it_mean_to_be_trans.txt", [question1, question2])

# aboutTrans.setRoot(aboutTrans.summaries[2])
# aboutTrans.setLayout(question1)
# aboutTrans.setLayout(aboutTrans.summaries[3], False)
# aboutTrans.setLayout(question2, False)
hint = RepeatingHint(["The definition of 'cisgender' is someone whose gender identity is the same as the sex they were assigned as at birth.", "Generally, transgender is a term which encompasses everyone who is not cisgender."])
# aboutTrans.setLayout(hint, False, False)

pronouns.getOutput("pronouns_output.txt")
aboutTrans.getOutput("about_trans_output.txt")
 
transIssues = Lesson("Transgender Issues", [aboutTrans, pronouns], "A lesson to teach about transgender issues and their importance.")



# twoPlusThree = Question("What is 2 + 3?", ["5", "4", "6", "3"], 0)
# fiveTimesFour = Question("What is 5 x 4?", ["5", "9", "54", "20"], 3)
# basicArithmetic = Topic("Maths!", [twoPlusThree, fiveTimesFour])
# basicArithmetic.setRoot(basicArithmetic.questions[0])
# basicArithmetic.setLayout(basicArithmetic.summaries[2], True, False)
# basicArithmetic.setLayout(basicArithmetic.summaries[1], True, True)
# basicArithmetic.setLayout(basicArithmetic.questions[1], False, True)
# hint = RepeatingHint(["Just add the numbers", "Come on it's 5 you stoopid"])
# basicArithmetic.setLayout(hint, True, False)
# basicArithmetic.setLayout("You did it!", True, True)
# print(basicArithmetic.layout)

# basicArithmetic.runTopic()

