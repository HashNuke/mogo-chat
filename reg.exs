{:ok, contents} = File.read("/Users/akashmanohar/projects/mogo-chat/test.css")

IO.inspect :direcs_lex.string('#{contents}')

# header_pattern = ~r/
#       \A (
#         (?m:\s*) (
#           (\/\* (?m:.*?) \*\/)) |
#           (\#\#\# (?m:.*?) \#\#\#) |
#           (\/\/ .* \n?)+ |
#           (\# .* \n?)+
#         )
#       )+
#     /x

# header_pattern = ~r"""
#   (\/\/\s*\=(?<directive>.*)(\s|\n)*)*
# """xmg

# header_pattern = ~r"""
#   (\/\/\s*\=(?<directive>.*)(\s|\n)*)*
# """xmg
# 
# IO.inspect Regex.named_captures(header_pattern, contents)
# 
# # lc r inlist Regex.scan(header_pattern, contents) do
# #   IO.inspect r
# # end