
import * as dotenv from 'dotenv'
import axios from 'axios'
import assert from 'assert'
import * as fs from 'fs'

dotenv.config()

const GPT_MODEL = 'gpt-3.5-turbo'
const BASE_URL = 'https://api.openai.com/v1/chat/'
const COMPLETION_EP = 'completions'

assert.equal(process.argv.length, 3)

const instance = axios.create({
    baseURL: BASE_URL,
    headers: { Authorization: `Bearer ${process.env.OPENAI_API_KEY}`}
})

type Message = { role: string, content: string }

async function get_response(messages: Array<Message>) {
    const res = await instance.post(COMPLETION_EP, {
        model: GPT_MODEL,
        messages: messages,
        temperature: 0
    })
    assert(res.data.choices.length == 1)
    return res.data.choices[0].message.content
}

//const yes_no_unknown_context = JSON.parse(fs.readFileSync('yes_no_unknown.json').toString())
const in_context_training = JSON.parse(fs.readFileSync('in_context_training.json').toString())

const test_name = process.argv[2]
const test_prompt = fs.readFileSync(`tests/${test_name}.txt`).toString()

async function run_test() {


    const user_prompt = {
        role: "user",
        content: test_prompt
    }

    const promises = [
        get_response([user_prompt]),
        get_response([...in_context_training, user_prompt])
    ]

    const responses = await Promise.all(promises)

    return {
        prompt: test_prompt,
        no_context_response: responses[0],
        smt_lib_response: responses[1]
    }
}


const out = await run_test()
fs.writeFileSync(`reports/${test_name}.json`, JSON.stringify(out, null, 4))
fs.writeFileSync(`smt/${test_name}.smt2`, out.smt_lib_response)
