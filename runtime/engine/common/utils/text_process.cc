#include "utils/text_process.h"

namespace ppspeech {

std::string DelBlank(const std::string& str) {
    std::string out = "";
    int ptr_in = 0;    //  the pointer of input string (for traversal)
    int end = str.size();
    int ptr_out = -1;  //  the pointer of output string (last char)
    while (ptr_in != end) {
        while (ptr_in != end && str[ptr_in] == ' ') {
            ptr_in += 1;
        }
        if (ptr_in == end) 
            return out;
        if (ptr_out != -1 && isalpha(str[ptr_in]) && isalpha(str[ptr_out]) && str[ptr_in-1] == ' ')
            // add a space when the last and current chars are in English and there have space(s) between them
            out += ' ';
        out += str[ptr_in];
        ptr_out = ptr_in;
        ptr_in += 1;
    }
    return out;
}

std::string AddBlank(const std::string& str) {
    std::string out = "";
    int ptr = 0;  // the pointer of the input string
    int end = str.size();
    while (ptr != end) {
        if (isalpha(str[ptr])) {
            if (ptr == 0 or str[ptr-1] != ' ')
                out += " ";  // add pre-space for an English word
            while (isalpha(str[ptr])) {
                out += str[ptr];
                ptr += 1;
            }
            out += " ";  // add post-space for an English word
        } else {
            out += str[ptr];
            ptr += 1;
        }
    }
    return out;
}

std::string ReverseFraction(const std::string& str) {
    std::string out = "";
    int ptr = 0;   // the pointer of the input string
    int end = str.size();
    int left, right, frac;  // the start index of the left tag, right tag and '/'.
    left = right = frac = 0;
    int len_tag = 5;  // length of "<tag>"

    while (ptr != end) {
        // find the position of left tag, right tag and '/'. (xxx<tag>num1/num2</tag>)
        left = str.find("<tag>", ptr);
        if (left == -1)
            break;
        out += str.substr(ptr, left - ptr);  // content before left tag (xxx)
        frac = str.find("/", left);
        right = str.find("<tag>", frac);
        
        out += str.substr(frac + 1, right - frac - 1) + '/' + 
               str.substr(left + len_tag, frac - left - len_tag);  // num2/num1
        ptr = right + len_tag;
    }
    if (ptr != end) {
        out += str.substr(ptr, end - ptr);
    }
    return out;
}

}  // namespace ppspeech