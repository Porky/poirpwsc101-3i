APP_NAME = 'Widdles In Shoes'
APP_VERSION = "V0.1."
APP_REVISION_DAY = "03"
APP_WIDTH = 400
APP_HEIGHT = 400
RIDDLES_FILE_NAME = 'WiddlesInShoes.riddles'

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
    stack :height => 75 do
        title "#{APP_NAME}", :stroke => red, :underline => 'single', :align => 'center', :size => 'medium'
    end # Heading

    # Body SLOT
    stack do

        # Question SLOT
        stack do
            flow do
                stack :width => 100 do
                    para "Question :", :size => 'small'
                end
                stack :width => -100 do
                    @question =  para "Question will go here", :size => 'small', :stroke => green
                end
            end
        end # Question

        # Answer SLOT
        stack do
            flow do
                stack :width => 100 do
                    para "Answer :", :size => 'small'
                end
                stack :width => -100 do
                    flow do
                        @answer = edit_line "Answer will go here"
                        para "  "
                        button "Check" do
                            @answerText = @answer.text
                            if  @answerText == @randomQuestion[1] then
                                @result.text = "Correct"
                                @questionResults[@questionNumber] = true
                                if allAnswered(@questionResults) == true then
                                    @status.text = "All answered correctly, please exit" # Finished
                                else
                                    @status.text = "Click Get Question button to display the next question"
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
                        end
                    end
                end
            end
        end # Answer

        # Result SLOT
        stack do
            flow do
                stack :width => 100 do
                    para "Result :", :size => 'small'
                end
                stack :width => -100 do
                    @result = para "Result will be displayed here.", :size => 'small', :stroke => green
                end
            end
        end # Result

        # Get next question button SLOT
        stack do
            self.move(0,APP_HEIGHT-150)
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
                    @result.text = "Result will be displayed here." # Reset result
                    @answer.text = ""                               # Clear last answer, if present
                    @answer.focus                                   # Move to answer box
                end
            end
        end # Get question

    end # Body

    # Status SLOT
    stack :height => 30 do
        self.move(0,APP_HEIGHT-30)
        background khaki
        @status = para "Status will be displayed here", :size => 'x-small', :stroke => gray
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
    @status.text = "Click Get Question button to display a random question"
    @getQuestion.focus

end
