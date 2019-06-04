require 'tk'
require 'oxford_dictionary'

class Tile


    def initialize(letter)
        @letter = letter
        determine_point_value()
    end

    def determine_point_value
        #1 point values include
        #A, D, E, G, I L, N, O, R, S, T, U
        if(@letter == 'A' || @letter == 'D' || @letter == 'E' ||@letter == 'G' || @letter == 'I' || @letter == 'L' || @letter == 'N' || @letter == 'O' || @letter == 'R' ||
            @letter == 'S' || @letter == 'T' || @letter == 'U')

            @point_value= 1
    
        #2 point values include
        #B, C, F, H, M, P, V, W, Y
        elsif(@letter == 'B' || @letter == 'C' || @letter == 'F' || @letter == 'H' || @letter == 'M' ||@letter == 'P' ||@letter == 'V' || @letter == 'W' || @letter == 'Y')
       
            @point_value = 2
        
        #3 point values include
        #J, K, Q, X, Z
        elsif(@letter == 'J' || @letter == 'K' || @letter == 'Q' || @letter == 'X' || @letter == 'Z')
            @point_value = 3
        end
    end

    def letter
        @letter
    end


    def letter=(letter)
        @letter = letter
        determine_point_value()
    end

    def point_value 
        @point_value
    end

    def point_value=(point_value)
        @point_value = point_value
    end

end




class TKInterface
    def initialize()

#Array that stores all correct words so the user cannot enter the same word multiple times
@correct_words = Array.new()
@word_scores = Array.new()

#Used to handle determination of words        
@client = OxfordDictionary::Client.new(app_id: '2b9d3818', app_key: '1f84d4dea2e9367d8e363155222e57ec')
@client = OxfordDictionary.new(app_id: '2b9d3818', app_key: '1f84d4dea2e9367d8e363155222e57ec')

@filename = "scores.txt"
@score = 0

@scores = Array.new()

def read_scores()
    file = File.open(@filename, "r")
    @data = file.read
    file.close
    processData(@data)

end

def processData(data)
    @scores = data.split(", ")
   
end

def set_hiscore_panel

scorehash = Hash.new()
names = Array.new()
hi_scores = Array.new()

delimiters = [':', ',']

score_file = File.open("scores.txt", "r")
scores_string = score_file.read()
score_file.close()

scores_with_names = scores_string.split(Regexp.union(delimiters))
counter = 0
while counter <= scores_with_names.length
    names.push(scores_with_names[counter])
    hi_scores.push(scores_with_names[counter+1].to_i)

    scorehash[scores_with_names[counter]] = scores_with_names[counter+1]
    counter+=2
end

hi_scores.sort!
hi_scores.reverse!




@hi_scores.configure(text: "Top 5 High Scores\n
    #{scorehash.key(hi_scores[0].to_s)} | #{hi_scores[0]} \n
    #{scorehash.key(hi_scores[1].to_s)} | #{hi_scores[1]} \n
    #{scorehash.key(hi_scores[2].to_s)} | #{hi_scores[2]} \n
    #{scorehash.key(hi_scores[3].to_s)} | #{hi_scores[3]} \n
    #{scorehash.key(hi_scores[4].to_s)} | #{hi_scores[4]}")

end

read_scores()

@root = TkRoot.new do
    title "Book Wyrm"
    background '#FFD989'
    minsize(1600, 900)
    maxsize(1600,900)
end

@battle_location = TkFrame.new(@root) do
    background '#FFE6C4'
    relief 'ridge'
    borderwidth 10 
    width 1000
    height 500
    #pack(side: 'top')
    grid(column: 1, row: 0)
end

@letter_holder = TkFrame.new(@root) do
    background '#FFC478'
    relief 'ridge'
    borderwidth 10 
    width 800
    height 400
    #pack(side: 'bottom')
    grid(column: 1, row: 1)
end

@player_information = TkFrame.new(@root) do
    background '#807362'
    relief 'ridge'
    borderwidth 10 
    width 400
    height 900
    grid(column:0, rowspan: 2, row:0)
end

@words_entered_label = TkLabel.new(@player_information) do
    font TkFont.new('courier 20 bold')
    background '#807362'
    relief 'ridge'
    borderwidth 10 
    width 15
    height 5
    text 'Words Entered'
    grid(column: 0, row:0)
end

@word_scored = TkListbox.new(@player_information) do
    font TkFont.new('courier 15 bold')
    background '#807362'
    relief 'ridge'
    borderwidth 10 
    width 20
    height 20
    
    grid(column: 0, row:1)
end

scroll_bar = TkScrollbar.new(@player_information,
    'command' => proc { |*args| @word_scored.yview *args })

scroll_bar.grid(row: 1, column: 3)


@word_scored.yscrollcommand(proc { |first,last|
               scroll_bar.set(first,last) })

@total_points = TkLabel.new(@player_information) do
    font TkFont.new('courier 15 bold')
    background '#807362'
    relief 'ridge'
    width 20
    height 5
    text 'Total Points: 0'
    grid(column:0, row:2)
end


@hi_score_info = TkFrame.new(@root) do
    background '#CCB89D'
    relief 'ridge'
    borderwidth 10 
    width 400
    height 900
    grid(column:2, rowspan: 2, row:0)
end

@hi_scores_label = TkLabel.new(@hi_score_info) do
text 'High Scores'
font TkFont.new('courier 20 bold')
background '#807362'
relief 'ridge'
borderwidth 10 
width 15
height 5
grid(column: 0, row: 0)
end

@hi_scores = TkLabel.new(@hi_score_info) do
font TkFont.new('courier 15 bold')
background '#807362'
relief 'ridge'
borderwidth 10 
width 20
height 20
text ''
grid(column: 0, row: 1)
end

set_hiscore_panel()

scramble_board = proc do
create_tiles()
set_buttons()
@scramble_points += 15
end

@scramble_button = TkButton.new(@hi_score_info) do

text 'SCRAMBLE (-15pts)'
command scramble_board
font TkFont.new('courier 15 bold')
background '#807362'
relief 'ridge'
width 20
height 3
grid(column: 0, row: 2)
borderwidth 5
end

end_game = proc do
@hi_score_info.destroy()
@player_information.destroy()
@letter_holder.destroy()
@battle_location.destroy()
    @submit_name = TkRoot.new do
    title 'Save Score'
    minsize(300, 100)
    maxsize(300,100)
end
@name_frame = TkFrame.new(@submit_name) do
    grid(column: 0, row: 0)
    pack(side: 'top')
height 100
width 100
end
@entry_label = TkLabel.new(@name_frame) do
grid(column: 0, row: 0)
font TkFont.new('courier 20 bold')
text 'Enter Your Name'
relief 'ridge'
borderwidth 10
end
@entry = TkEntry.new(@name_frame) do
font TkFont.new('courier 12 bold')
grid(column: 0, row: 1)
end

submit_score_pressed = proc do
@player_name = @entry.get()
scores_file = File.open(@filename, 'w')
@scores.push("#{@player_name}:#{@score}")
scores_file.print @scores.join(",")
scores_file.close()
@submit_name.destroy()
end

@submit_score = TkButton.new(@name_frame) do
text 'Submit'
font TkFont.new('courier 12 bold')
grid(column: 0, row: 2)
command submit_score_pressed
end



end
@end_button = TkButton.new(@hi_score_info) do
grid(column: 0, row:3)
command end_game
text 'Finish and Save Score'
font TkFont.new('courier 15 bold')
width 20
height 2
borderwidth 5
end


def evaluate_word(word)

    counter = 0

    point_counter = 0
    wordup = word.upcase

    while counter <= word.length
        @Evaluated_Tile = Tile.new(wordup[counter])

        point_counter += @Evaluated_Tile.point_value.to_i
        counter+=1
    end

    return point_counter

end


def create_tiles
#Creation of Tiles
@letterarray = Array.new
counter1 = 0

loop do
randletter = rand(65...90)
@letterarray.push(randletter.chr)
counter1 +=1
if(counter1 >= 16)
break
end
end

@TileArray = [
Tile.new(@letterarray[0]),
Tile.new(@letterarray[1]),
Tile.new(@letterarray[2]),
Tile.new(@letterarray[3]),
Tile.new(@letterarray[4]),
Tile.new(@letterarray[5]),
Tile.new(@letterarray[6]),
Tile.new(@letterarray[7]),
Tile.new(@letterarray[8]),
Tile.new(@letterarray[9]),
Tile.new(@letterarray[10]),
Tile.new(@letterarray[11]),
Tile.new(@letterarray[12]),
Tile.new(@letterarray[13]),
Tile.new(@letterarray[14]),
Tile.new(@letterarray[15]),
]

end

create_tiles()

@wordarray = Array.new(0)
@wordreal = Array.new(0)

def clear_word
@wordreal = Array.new(0)
@wordarray = Array.new(0)
@wordshow.configure(text: "#{@wordreal.join('')}")
end

def update_word(letter)
if(@messageon)
clear_word()
@messageon = false
end
@wordreal.clear()
@wordarray.push(letter)
i = 0
while i <= @wordarray.length do
 @wordreal.push(@wordarray[i])
 i+=1
end
@wordshow.configure(text: "#{@wordreal.join('')}")
end

@wordshow = TkLabel.new(@battle_location) do
background '#000'
foreground '#FFF'
text ''
font TkFont.new('courier 20 bold')
width 63
height 5
grid(column: 0, row:0)

end

@scramble_points = 0

enter_word = proc do


@realword = false

if(@wordreal.join('').length > 2)
if(!@correct_words.include? @wordreal.join('').upcase)
begin
    word = @client.entry(@wordreal.join('').downcase)
    @realword = true
    @word_scores.push(evaluate_word(@wordreal.join('').downcase))
    @correct_words.push(@wordreal.join('').upcase)

    scores_string = Array.new()
    counter = 0
    counter2 = 0
    point_counter = 0

    while counter < @correct_words.length
        scores_string.push("#{@correct_words[counter]} | #{@word_scores[counter]}\n")
        counter+=1
    end

    while counter2 < @word_scores.length
        point_counter += @word_scores[counter2].to_i
        counter2+=1
    end

    point_counter -= @scramble_points

    @score = point_counter 
    @total_points.configure(text: "Total Points: #{point_counter.to_s}")
    #@word_scored.configure(text: "#{scores_string.join('')}")

    string_counter = 0
    @word_scored.clear
    while string_counter < scores_string.length do
        
        @word_scored.insert 0, (scores_string[string_counter])
        string_counter+=1
    end
    #Changing tiles when used
    tilecounter = 0
    while tilecounter < @usedTiles.length

        @TileArray[tilecounter] = @usedTiles[tilecounter]
        tilecounter+=1
    end

    set_buttons()

rescue
@usedTiles = @TileArray.clone()
@realword = false
end
@messageon = false
clear_word()
if(!@realword)
update_word('N')
update_word('O')
update_word('T')
update_word(' ')
update_word('A')
update_word(' ')
update_word('W')
update_word('O')
update_word('R')
update_word('D')
@messageon = true

elsif(@realword)

update_word('G')
update_word('O')
update_word('O')
update_word('D')
update_word(' ')
update_word('J')
update_word('O')
update_word('B')
@messageon = true
end

else
clear_word()
update_word('A')
update_word('L')
update_word('R')
update_word('E')
update_word('A')
update_word('D')
update_word('Y')
update_word(' ')
update_word('E')
update_word('N')
update_word('T')
update_word('E')
update_word('R')
update_word('E')
update_word('D')
@messageon = true


end
else
clear_word()
update_word('T')
update_word('O')
update_word('O')

update_word(' ')

update_word('F')
update_word('E')
update_word('W')

update_word(' ')

update_word('L')
update_word('E')
update_word('T')
update_word('T')
update_word('E')
update_word('R')
update_word('S')
@messageon = true
@usedTiles = @TileArray
end
@button00.configure(state: 'normal')
@button01.configure(state: 'normal')
@button02.configure(state: 'normal')
@button03.configure(state: 'normal')

@button10.configure(state: 'normal')
@button11.configure(state: 'normal')
@button12.configure(state: 'normal')
@button13.configure(state: 'normal')

@button20.configure(state: 'normal')
@button21.configure(state: 'normal')
@button22.configure(state: 'normal')
@button23.configure(state: 'normal')

@button30.configure(state: 'normal')
@button31.configure(state: 'normal')
@button32.configure(state: 'normal')
@button33.configure(state: 'normal')
end

@submit_word = TkButton.new(@letter_holder) do

grid(column: 0, row: 4, columnspan: 4)
width 47
height 5
text 'Submit Your Word'
relief 'raised'
borderwidth 5
command enter_word
end

def update_tile(updated_tile)
randnum = rand(65...90)
letter = randnum.chr
updated_tile = Tile.new(letter)
return updated_tile
end

@usedTiles = @TileArray.clone()

#Row 1
button00_clicked = proc do
update_word(@TileArray[0].letter)
@button00.configure(state: 'disabled')
@usedTiles[0] = update_tile(@usedTiles[0])
end

button01_clicked = proc do
update_word(@TileArray[1].letter)
@button01.configure(state: 'disabled')
@usedTiles[1] = update_tile(@usedTiles[1])
end

button02_clicked = proc do
update_word(@TileArray[2].letter)
@button02.configure(state: 'disabled')
@usedTiles[2] = update_tile(@usedTiles[2])
end

button03_clicked = proc do
update_word(@TileArray[3].letter)
@button03.configure(state: 'disabled')
@usedTiles[3] = update_tile(@usedTiles[3])
end

#Row 2
button10_clicked = proc do
update_word(@TileArray[4].letter)
@button10.configure(state: 'disabled')
@usedTiles[4] = update_tile(@usedTiles[4])
end

button11_clicked = proc do
update_word(@TileArray[5].letter)
@button11.configure(state: 'disabled')
@usedTiles[5] = update_tile(@usedTiles[5])
end

button12_clicked = proc do
update_word(@TileArray[6].letter)
@button12.configure(state: 'disabled')
@usedTiles[6] = update_tile(@usedTiles[6])
end

button13_clicked = proc do
update_word(@TileArray[7].letter)
@button13.configure(state: 'disabled')
@usedTiles[7] = update_tile(@usedTiles[7])
end

#Row 3
button20_clicked = proc do
update_word(@TileArray[8].letter)
@button20.configure(state: 'disabled')
@usedTiles[8] = update_tile(@usedTiles[8])
end

button21_clicked = proc do
update_word(@TileArray[9].letter)
@button21.configure(state: 'disabled')
@usedTiles[9] = update_tile(@usedTiles[9])
end

button22_clicked = proc do
update_word(@TileArray[10].letter)
@button22.configure(state: 'disabled')
@usedTiles[10] = update_tile(@usedTiles[10])
end

button23_clicked = proc do
update_word(@TileArray[11].letter)
@button23.configure(state: 'disabled')
@usedTiles[11] = update_tile(@usedTiles[11])
end

#Row 4

button30_clicked = proc do
update_word(@TileArray[12].letter)
@button30.configure(state: 'disabled')
@usedTiles[12] = update_tile(@usedTiles[12])
end

button31_clicked = proc do
update_word(@TileArray[13].letter)
@button31.configure(state: 'disabled')
@usedTiles[13] = update_tile(@usedTiles[13])
end

button32_clicked = proc do
update_word(@TileArray[14].letter)
@button32.configure(state: 'disabled')
@usedTiles[14] = update_tile(@usedTiles[14])
end

button33_clicked = proc do
update_word(@TileArray[15].letter)
@button33.configure(state: 'disabled')
@usedTiles[15] = update_tile(@usedTiles[15])
end

@button00 = TkButton.new(@letter_holder) do
width 10
height 4
text 'cat'
relief 'raised'
disabledforeground '#A9A9A9'
grid(column: 0, row: 0)
command button00_clicked
borderwidth 5
background '#FFF'
relief 'ridge'
end


@button01 = TkButton.new(@letter_holder) do
        width 10
        height 4
        text 'Tile1'
        relief 'raised'
        grid(column: 0, row: 1)
        command button01_clicked
        borderwidth 5
        background '#FFF'
        relief 'ridge'
    end

@button02 = TkButton.new(@letter_holder) do
        width 10
        height 4
        text 'Tile1'
        relief 'raised'
        grid(column: 0, row: 2)
        command button02_clicked
        borderwidth 5
        background '#FFF'
        relief 'ridge'
    end
@button03 = TkButton.new(@letter_holder) do
        width 10
        height 4
        text 'Tile1'
        relief 'raised'
        grid(column: 0, row: 3)
        command button03_clicked
        borderwidth 5
        background '#FFF'
        relief 'ridge'
    end  
    
@button10 = TkButton.new(@letter_holder) do
        width 10
        height 4
        text 'Tile1'
        relief 'raised'
        grid(column: 1, row: 0)
        command button10_clicked
        borderwidth 5
        background '#FFF'
        relief 'ridge'
    end    
@button11 = TkButton.new(@letter_holder) do
        width 10
        height 4
        text 'Tile1'
        relief 'raised'
        grid(column: 1, row: 1)
        command button11_clicked
        borderwidth 5
        background '#FFF'
        relief 'ridge'
    end

@button12 = TkButton.new(@letter_holder) do
        width 10
        height 4
        text 'Tile1'
        relief 'raised'
        grid(column: 1, row: 2)
        command button12_clicked
        borderwidth 5
        background '#FFF'
        relief 'ridge'
    end

@button13 = TkButton.new(@letter_holder) do
        width 10
        height 4
        text 'Tile1'
        relief 'raised'
        grid(column: 1, row: 3)
        command button13_clicked
        borderwidth 5
        background '#FFF'
        relief 'ridge'
    end    

@button20 = TkButton.new(@letter_holder) do
        width 10
        height 4
        text 'Tile1'
        relief 'raised'
        grid(column: 2, row: 0)
        command button20_clicked
        borderwidth 5
        background '#FFF'
        relief 'ridge'
    end

    @button21 = TkButton.new(@letter_holder) do
        width 10
        height 4
        text 'Tile1'
        relief 'raised'
        grid(column: 2, row: 1)
        command button21_clicked
        borderwidth 5
        background '#FFF'
        relief 'ridge'
    end

    @button22 = TkButton.new(@letter_holder) do
        width 10
        height 4
        text 'Tile1'
        relief 'raised'
        grid(column: 2, row: 2)
        command button22_clicked
        borderwidth 5
        background '#FFF'
        relief 'ridge'
    end
    @button23 = TkButton.new(@letter_holder) do
        width 10
        height 4
        text 'Tile1'
        relief 'raised'
        grid(column: 2, row: 3)
        command button23_clicked
        borderwidth 5
        background '#FFF'
        relief 'ridge'
    end

@button30 = TkButton.new(@letter_holder) do
        width 10
        height 4
        text 'Tile1'
        relief 'raised'
        grid(column: 3, row: 0)
        command button30_clicked
        borderwidth 5
        background '#FFF'
        relief 'ridge'
    end

@button31 = TkButton.new(@letter_holder) do
        width 10
        height 4
        text 'Tile1'
        relief 'raised'
        grid(column: 3, row: 1)
        command button31_clicked
        borderwidth 5
        background '#FFF'
        relief 'ridge'
    end

@button32 = TkButton.new(@letter_holder) do
        width 10
        height 4
        text 'Tile1'
        relief 'raised'
        grid(column: 3, row: 2)
        command button32_clicked
        borderwidth 5
        background '#FFF'
        relief 'ridge'
    end

@button33 = TkButton.new(@letter_holder) do
        width 10
        height 4
        text 'Tile1'
        relief 'raised'
        grid(column: 3, row: 3)
        command button33_clicked
        borderwidth 5
        background '#FFF'
        relief 'ridge'
    end

def set_buttons
@button00.configure(text: @TileArray[0].letter)
@button01.configure(text: @TileArray[1].letter)  
@button02.configure(text: @TileArray[2].letter)  
@button03.configure(text: @TileArray[3].letter)  
@button10.configure(text: @TileArray[4].letter)  
@button11.configure(text: @TileArray[5].letter)  
@button12.configure(text: @TileArray[6].letter)  
@button13.configure(text: @TileArray[7].letter)  
@button20.configure(text: @TileArray[8].letter)  
@button21.configure(text: @TileArray[9].letter)  
@button22.configure(text: @TileArray[10].letter)  
@button23.configure(text: @TileArray[11].letter)  
@button30.configure(text: @TileArray[12].letter)  
@button31.configure(text: @TileArray[13].letter)  
@button32.configure(text: @TileArray[14].letter)  
@button33.configure(text: @TileArray[15].letter)    
end
set_buttons()
end
end

BookWyrm = TKInterface.new()
Tk.mainloop
