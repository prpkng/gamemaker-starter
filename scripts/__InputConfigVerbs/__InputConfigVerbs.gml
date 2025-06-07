function __InputConfigVerbs()
{
    enum INPUT_VERB
    {
        //Add your own verbs here!
        LEFT,
        RIGHT,
        JUMP
    }
    
    InputDefineVerb(INPUT_VERB.LEFT, "left", [vk_left, ord("A")], [gp_padl, -gp_axislh]);
    InputDefineVerb(INPUT_VERB.RIGHT, "right", [vk_right, ord("D")], [gp_padr, gp_axislh]);
    InputDefineVerb(INPUT_VERB.JUMP, "jump", [vk_space, ord("Z")], gp_face1);
}