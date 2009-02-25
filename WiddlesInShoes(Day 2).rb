NAME = 'Widdles In Shoes'
VERSION = "V0.1"

Shoes.app \
    :title => "#{NAME} #{VERSION}",
    :width => 400, :height => 400,
    :resizable => false \
do

    background darkgreen
    background mediumaquamarine..aquamarine, :angle => 90, :curve => 10, :margin => 5

end
