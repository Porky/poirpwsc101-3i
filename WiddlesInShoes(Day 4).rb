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

    background blue # For corners
    background gold..yellow, :angle => 90, :curve => 15

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
    end

    # Read in riddles from file
    @riddles = IO.readlines(RIDDLES_FILE_NAME)
    @numberOfQuestions = @riddles.size

    stack do
        title "#{APP_NAME}", :stroke => red, :underline => 'single', :align => 'center', :size => 'medium'

        @questionResults = Array.new(@numberOfQuestions,false)        # Elements will hold true for correct questions

        # Initial display of stars
        displayStars(@questionResults)
        para " "

    end

    # Get a random question/answer for the time being
    @questionNumber = rand(@numberOfQuestions)
    @randomQuestion = @riddles[@questionNumber].chomp.split(", ")

    stack do
        stack do
            flow do
                stack :width => 100 do
                    para "Question :", :size => 'small'
                end
                stack :width => -100 do
                    @question =  para @randomQuestion[0], :size => 'small', :stroke => green
                end
            end
        end
        
        stack do
            flow do
                stack :width => 100 do
                    para "Answer :", :size => 'small'
                end
                stack :width => -100 do
                    flow do
                        @answer = edit_line "Type answer here"
                        para "  "
                        button "Check" do
                            @answerText = @answer.text
                            if  @answerText == @randomQuestion[1] then
                                @score.text = "Correct"
                                @questionResults[@questionNumber] = true
                            else
                                @score.text = "Wrong"
                                @questionResults[@questionNumber] = false
                            end
                            # Redisplay stars status
                            displayStars(@questionResults)
                        end
                    end
                end
            end
        
        end
        
        stack do
            flow do
                stack :width => 100 do
                    para "Score :", :size => 'small'
                end
                stack :width => -100 do
                    @score = para "The result will show here, for the time being.", :size => 'small', :stroke => green
                end
            end
        
        end

    end

end
