APP_NAME = 'Widdles In Shoes'
APP_VERSION = "V0.1."
APP_REVISION_DAY = "03"
APP_WIDTH = 400
APP_HEIGHT = 400
LEFT_COLUMN_WIDTH = APP_WIDTH/4
HEADING_HEIGHT = APP_HEIGHT/5
STATUS_HEIGHT = APP_HEIGHT/16
BUTTON_HEIGHT = (APP_HEIGHT/3.50).to_i
RIDDLES_FILE_NAME = 'WiddlesInShoes.riddles'

# Add center methods to Button Class - Thanks Krzysztof, James & Dave
class Shoes::Button
    def center
        @left= self.parent.class==Shoes ? (self.app.width-self.width)/2 : (self.parent.width-self.width)/2
        self.move(@left,self.top)
    end
end


Shoes.app \
    :title => "#{APP_NAME} #{APP_VERSION}#{APP_REVISION_DAY}",
    :width => APP_WIDTH, :height => APP_HEIGHT,
    :resizable => false \
do

    background gold..yellow, :angle => 90

    #######################
    # Application Methods #
    #######################

    # Display Stars
    def displayStars(results)
        results.each_with_index do |result,element|
            if result == true then
                stroke red
                fill blue
            else
                stroke blue
                fill red
            end
            # TODO - Calculate left offset and spacing according to number of questions
            star(90+(25 * element), 50, points = 6, outer = 10, inner = 4)
        end
    end # Display Stars

    # Check if all questions have been answered (returns true/false)
    def allAnswered(results)
        done = true
        results.each do |result|
            done = false if result == false
        end
        return done
    end

    #####################################
    # Application Layout and Event Code #
    #####################################

    # Heading - Includes space for stars reflecting status of questions
    stack :height => HEADING_HEIGHT do
        title "#{APP_NAME}", :stroke => red, :underline => 'single', :align => 'center', :size => 'medium'
    end # Heading

    # Body SLOT
    stack do

        # Question SLOT
        stack do
            flow do
                stack :width => LEFT_COLUMN_WIDTH do
                    para "Question :", :size => 'small'
                end
                stack :width => -LEFT_COLUMN_WIDTH do
                    @question =  para "Question will go here", :size => 'small', :stroke => green
                end
            end
        end # Question

        # Answer SLOT
        stack do
            flow do
                stack :width => LEFT_COLUMN_WIDTH do
                    para "Answer :", :size => 'small'
                end
                stack :width => -LEFT_COLUMN_WIDTH do
                    flow do
                        @answer = edit_line "Answer will go here"
                        para "  "
                        @check = button "Check" do
                            @answerText = @answer.text
                            if  @answerText == @randomQuestion[1] then
                                @result.text = "Correct"
                                @questionResults[@questionNumber] = true
                                if allAnswered(@questionResults) == true then
                                    @status.text = "All answered correctly, please exit" # Finished
                                else
                                    @status.text = "Click [Get Question] to display the next question"
                                    @getQuestion.focus
                                end
                            else
                                @result.text = "Wrong"
                                @questionResults[@questionNumber] = false
                                @status.text = "Re-enter answer"
                                @answer.focus
                            end
                            # Redisplay stars status
                            displayStars(@questionResults)
                            if allAnswered(@questionResults) == true then
                                alert("All answered correctly, please exit")
                            end
                        end
                    end
                end
            end
        end # Answer

        # Result SLOT
        stack do
            flow do
                stack :width => LEFT_COLUMN_WIDTH do
                    para "Result :", :size => 'small'
                end
                stack :width => -LEFT_COLUMN_WIDTH do
                    @result = para "Result will go here.", :size => 'small', :stroke => green
                end
            end
        end # Result

        # Get next question button SLOT
        stack :left =>1, :top => APP_HEIGHT-(BUTTON_HEIGHT+STATUS_HEIGHT), :height => BUTTON_HEIGHT do
            @getQuestion = button "Get Question" do
                # Check if we have correctly answered them all
                if allAnswered(@questionResults) == true then
                    @status.text = "All answered correctly, please exit" # Finished
                else
                    # Get a random unanswered question (There must be at least one left)
                    begin
                        @questionNumber = rand(@numberOfQuestions)
                    end until @questionResults[@questionNumber] == false
                    # Set up the details
                    @randomQuestion = @riddles[@questionNumber].chomp.split(", ")
                    @question.text =  @randomQuestion[0]            # Display question
                    @randomQuestion[1].delete!("\"")                # Strip off quotes from correct answer
                    @status.text = "Enter answer"                   # What we want them to do
                    @result.text = ""                               # Reset result
                    @answer.text = ""                               # Clear last answer, if present
                    @answer.focus                                   # Move to answer box
                end
            end
            start{@getQuestion.center
                  @getQuestion.focus}                              # Set button to center of  SLOT and set focus
        end # Get question

    end # Body

    # Status SLOT
    stack :height => STATUS_HEIGHT do
        self.move(0,APP_HEIGHT-STATUS_HEIGHT)
        background khaki
        @status = para "Status will go here", :size => 'xx-small', :stroke => black
    end # Status

    #####################################
    # Application Processing Start Code #
    #####################################

    # Read in riddles and display initial status of questions
    @status.text = "Reading in riddles from file"
    @riddles = IO.readlines(RIDDLES_FILE_NAME)
    @numberOfQuestions = @riddles.size
    @questionResults = Array.new(@numberOfQuestions,false)     # Elements will hold true for correct questions
    displayStars(@questionResults)                             # Initial status

    # Tell them how to start
    @status.text = "Click [Get Question] to display the first random question"

end
