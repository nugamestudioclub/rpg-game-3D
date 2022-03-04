using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CharacterAnimationController : MonoBehaviour
{
    public Animator anim;
    private bool walking;
    private bool running;
    private bool jumping;
    private bool falling;

    public static string param_waking = "Walking";
    public static string param_jumping = "Jumping";
    public static string param_falling = "Falling";
    public static string param_running = "Running";
    public static string param_attack = "Attack";
    public static string param_attackNumber = "AttackNumber";

    [Tooltip("'horizontal','vertical' for walking, 'running' for running, 'jump' for jumping")]
    [SerializeField]
    private bool inputEnabled;

    // Start is called before the first frame update
    void Start()
    {
        
    }

    /// <summary>
    /// Starts jump animation
    /// </summary>
    /// <param name="onGround">If you're on ground, set to true, if you want to fall set true. Default false</param>
    public void Jump(bool onGround=false)
    {
        this.jumping = true;
        if(onGround)
            this.falling = onGround;

        anim.SetBool(param_jumping, jumping);
    }
    /// <summary>
    /// If you jumped with onGround as true, you call Land() to ensure that falling
    /// stops.
    /// </summary>
    public void StopFall()
    {
        this.falling = false;
    }

    public void StartFall()
    {
        this.falling = true;
    }
    
    public void Walk()
    {
        this.walking = true;
        this.running = false;
    }
    public void Run()
    {
        this.walking = false;
        this.running = true;
    }
    public void Idle()
    {
        this.running = false;
        this.falling = false;
        this.jumping = false;
        this.walking = false;
    }


    // Update is called once per frame
    void Update()
    {
        //TestUpdate();
        if (this.inputEnabled)
            this.inputUpdate();

        anim.SetBool(param_waking, walking);
        anim.SetBool(param_running, running);
        
        anim.SetBool(param_falling, falling);
    }

    private void TestUpdate()
    {
        if (Input.GetAxis("Vertical") > 0.5f)
        {
            print("Running!");
            if (Input.GetKey(KeyCode.LeftShift))
            {
                this.Run();
            }
            else
            {
                this.Walk();
            }


        }
        else
        {
            this.Idle();
        }

        if (Input.GetButtonDown("Jump"))
        {
            this.Jump(false);
        }
    }


    private void inputUpdate()
    {
        float x = Input.GetAxis("Horizontal");
        float y = Input.GetAxis("Vertical");
        if (Mathf.Abs(x) > 0 || Mathf.Abs(y) > 0)
        {
            if (Input.GetButton("Running"))
            {
                this.Run();
            }
            else
            {
                this.Walk();
            }
        }
        else
        {
            this.Idle();
        }

        if (Input.GetButtonDown("Jump"))
        {
            this.Jump();
        }
        
    }
}
