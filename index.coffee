user   = 'boudydegeer'        # put your codeivate user here


command: "curl -s 'http://codeivate.com/users/#{user}.json'"

refreshFrequency: 600000

$domEl : null

render: (o) -> """
  <div class='big'>
    <div class='level'></div>
    <div class='programing-lang'></div>
    <div class='summary'>

    </div>
  </div>
  <div class='languages'></div>
"""

update: (output, domEl) ->
  @$domEl = $(domEl)
  data  = JSON.parse(output)

  @setLevel( data )

  if @isProgramming(data)
    @setColor ".level", @color["green"]
    @showsSummaryMessage( "Is programing right now" ) and
    @setCurrentLanguage( data )

  if @isOnStreak(data)
    @setColor ".level", @color["yellow"]
    @appendSummaryMessage("and is on a Streak")

  @renderLanguages( data.languages )

renderLanguages: ( languages ) ->
  languagesContainer = @$domEl.find '.languages'
  languagesContainer.html ""

  for key, value of languages
    languagesContainer.append @renderLanguage key, value

renderLanguage: ( language, details ) ->
  level = ( parseFloat details.level / 2)
  output = """
    <span class='language #{language}' style='font-size:#{level}em'>
     #{language}
    </span>
  """
  output

style: """
  top: 250px
  left: 20px
  color: #fff
  font-family: Helvetica Neue
  text-align: center
  width: 340px


  .big
    display: inline-block
    text-align: left
    position: relative
    width : 340px
    min-height: 100px

  .level
    font-family: Helvetica Neue
    font-size: 5em
    font-weight: 100
    line-height: 70px
    position: absolute
    left: 0
    top: 0
    vertical-align: middle

  .programing-lang
    right: 0
    position: absolute
    font-weight: 200
    font-size: 32px
    text-align: right


  .summary
    font-size: 14px
    text-align: right
    line-height: 1.5
    color: #fff
    margin-top: 40px
    right: 0
    position: absolute


  .languages
    padding-top: 10px
    border-top: 1px solid #fff

  .languages .language
    display: inline-block
    margin-right: 40px
    text-align: center


"""

color:
  "green"               :"#468847"
  "yellow"              :"#fbb450"
  "blue"                :"#149bdf"


isProgramming: (data) ->
  data.programming_now

isOnStreak: (data)->
  data.streaking_now

showsSummaryMessage: (message)->
  summary = @$domEl.find ".summary"
  @showsMessage summary, message

appendSummaryMessage: (message)->
  summary = @$domEl.find ".summary"
  @appendMessage summary, message

showsMessage: (element, message)->
  element.html message

appendMessage: (element, message)->
  element.append """
    <br/> #{message}
  """
setCurrentLanguage: (data)->
  current = @$domEl.find ".programing-lang"
  @showsMessage current, data.current_language
setColor: (item, color) ->
  @$domEl.find(item).css "color", color
setLevel: ( data )->
  @$domEl.find('.level').html data.level