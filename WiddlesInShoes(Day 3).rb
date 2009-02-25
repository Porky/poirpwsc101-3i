APP_NAME = 'Widdles In Shoes'
APP_VERSION = "V0.1."
APP_REVISION_DAY = "03"
APP_WIDTH = 400
APP_HEIGHT = 400
NUMBER_OF_QUESTIONS = 10

Shoes.app \
    :title => "#{APP_NAME} #{APP_VERSION}#{APP_REVISION_DAY}",
    :width => APP_WIDTH, :height => APP_HEIGHT,
    :resizable => false \
do
    background blue # For corners
    background gold..yellow, :angle => 90, :curve => 15

    stack \
    do
        title "#{APP_NAME}", :stroke => red, :underline => 'single', :align => 'center'

        questionResult = Array.new(NUMBER_OF_QUESTIONS,false)        # Elements will hold true for correct questions

        # This next section should be a method, so it can be called to change
        # the display as a question is correctly answered. The intention is to display
        # stars for correctly answered questions in a different colour

        questionResult[3] = true # Just to show it works
        questionResult[5] = true # Just to show it works
        
        #Build up a list of stars, differenly coloured if answered correctly
        questionResult.each_with_index \
        do |result,element|
            if result == true then
                stroke red
                fill blue
            else
                stroke blue
                fill red
            end
            star(90+(25 * element), 70, points = 6, outer = 10, inner = 4)
        end

        para " "

    end
        
    stack \
    do
        stack \
        do
            subtitle "Question :"
        
        end
        
        stack \
        do
            subtitle "Answer :"
        
        end
        
        stack \
        do
            subtitle "Score :"
        
        end

    end

end
